#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: transmission
# Provider:: torrent_file
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'digest/sha1'
require 'chef/mixin/checksum'
include Chef::Mixin::Checksum
include Opscode::Transmission

def load_current_resource
  @current_resource = Chef::Resource::TransmissionTorrentFile.new(@new_resource.name)
  Chef::Log.debug("#{@new_resource} torrent hash = #{torrent_hash}")
  @transmission = Opscode::Transmission::Client.new("http://#{@new_resource.rpc_username}:#{@new_resource.rpc_password}@#{@new_resource.rpc_host}:#{@new_resource.rpc_port}/transmission/rpc")
  @torrent = nil
  begin
    @torrent = @transmission.get_torrent(torrent_hash)
    Chef::Log.info("Found existing #{@new_resource} in swarm with name of '#{@torrent.name}' and status of '#{@torrent.status_message}'")
    @current_resource.torrent(@new_resource.torrent)
  rescue
    Chef::Log.debug("Cannot find #{@new_resource} in the swarm")
  end
  @current_resource
end

action :create do
  unless exists?  
    unless @torrent
      @torrent = @transmission.add_torrent(cached_torrent)
      Chef::Log.info("Added #{@new_resource} to the swarm with a name of '#{@torrent.name}'")
      if @new_resource.blocking
        begin
          @torrent = @transmission.get_torrent(@torrent.hash_string)
          Chef::Log.debug("Downloading #{@new_resource}...#{@torrent.percent_done * 100}% complete")
          sleep 3
        end while @torrent.downloading?
        move_and_clean_up
        new_resource.updated_by_last_action(true)
      end
    else
      unless @new_resource.blocking || @torrent.downloading?
        move_and_clean_up
        new_resource.updated_by_last_action(true)
      else
        Chef::Log.debug("Downloading #{@new_resource}...#{@torrent.percent_done * 100}% complete")
      end
    end
  end
end

private

def exists?
  ::File.exists?(new_resource.path)
end

def move_and_clean_up
  Chef::Log.info("#{@new_resource} download completed in #{(Time.now.to_i - @torrent.start_date)} seconds")
  torrent_download_path = ::File.join(@torrent.download_dir, @torrent.files.first.name)
  if new_resource.continue_seeding
    link new_resource.path do
      to torrent_download_path
      owner new_resource.owner
      group new_resource.group
    end
  else
    f = file @new_resource.path do
      content IO.read(torrent_download_path)
      backup false
      owner new_resource.owner
      group new_resource.group
    end
    f.run_action(:create)
    @transmission.remove_torrent(@torrent.hash_string, true) 
  end
end

def cached_torrent
  @@torrent_file_path ||= begin
    cache_file_path = "#{Chef::Config[:file_cache_path]}/#{::File.basename(new_resource.torrent)}"
    Chef::Log.debug("Caching a copy of torrent file #{new_resource.torrent} at #{cache_file_path}")
    if(new_resource.torrent =~ /^(https?:\/\/)(.*\/)(.*\.torrent)$/)
      r = remote_file cache_file_path do
        source new_resource.torrent
        backup false
        mode "0755"
      end
    else
      r = file cache_file_path do
        content IO.read(new_resource.torrent)
        backup false
        mode "0755"
      end
    end
    r.run_action(:create)
    cache_file_path
  end
end

def torrent_hash
  require 'bencode'
  @@torrent_hash ||= begin
    Digest::SHA1.hexdigest((IO.read(cached_torrent).bdecode["info"]).bencode) # thx bakins!
  end
end
