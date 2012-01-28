#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Provider:: ark
#
# Copyright 2011, Bryan w. Berry
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

def parse_app_dir_name url
  file_name = url.split('/')[-1]
  # funky logic to parse oracle's non-standard naming convention
  # for jdk1.6
  if file_name =~ /^(jre|jdk).*$/
    major_num = file_name.scan(/\d/)[0]
    update_num = file_name.scan(/\d+/)[1]
    # pad a single digit number with a zero
    if update_num.length < 2
      update_num = "0" + update_num
    end
    package_name = file_name.scan(/[a-z]+/)[0]
    app_dir_name = "#{package_name}1.#{major_num}.0_#{update_num}"
  else
    app_dir_name = file_name.split(/(.tar.gz|.zip)/)[0]
    app_dir_name = app_dir_name.split("-bin")[0]
  end
  [app_dir_name, file_name]
end

action :install do
  app_dir_name, tarball_name = parse_app_dir_name(new_resource.url)
  app_root = new_resource.app_home.split('/')[0..-2].join('/')
  app_dir = app_root + '/' + app_dir_name

  unless new_resource.default
    Chef::Log.debug("processing alternate jdk")
    app_dir = app_dir  + "_alt"
    app_home = app_dir
  else
    app_home = new_resource.app_home
  end
  
  unless ::File.exists?(app_dir)
    Chef::Log.info "Adding #{new_resource.name} to #{app_dir}"
    require 'fileutils'
    
    unless ::File.exists?(app_root)
      FileUtils.mkdir app_root, :mode => new_resource.app_home_mode
      FileUtils.chown new_resource.owner, new_resource.owner, app_root
    end

    r = remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
      source new_resource.url
      checksum new_resource.checksum
      mode 0755
      action :nothing
    end
    r.run_action(:create_if_missing)
    
    require 'tmpdir'
    
    tmpdir = Dir.mktmpdir
    case tarball_name
    when /^.*\.bin/
      cmd = Chef::ShellOut.new(
                               %Q[ cd "#{tmpdir}";
                                   cp "#{Chef::Config[:file_cache_path]}/#{tarball_name}" . ;
                                   bash ./#{tarball_name} -noregister
                                 ] ).run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end
    when /^.*\.zip/
      cmd = Chef::ShellOut.new(
                         %Q[ unzip "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -d "#{tmpdir}" ]
                               ).run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end
    when /^.*\.tar.gz/
      cmd = Chef::ShellOut.new(
                         %Q[ tar xvzf "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -C "#{tmpdir}" ]
                               ).run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end
    end

    cmd = Chef::ShellOut.new(
                       %Q[ mv "#{tmpdir}/#{app_dir_name}" "#{app_dir}" ]
                             ).run_command
    unless cmd.exitstatus == 0
        Chef::Application.fatal!(%Q[ Command \' mv "#{tmpdir}/#{app_dir_name}" "#{app_dir}" \' failed ])
      end
    FileUtils.rm_r tmpdir
    new_resource.updated_by_last_action(true)
  end

  #update-alternatives
  if new_resource.default
    Chef::Log.debug "app_home is #{app_home} and app_dir is #{app_dir}"
    current_link = ::File.symlink?(app_home) ? ::File.readlink(app_home) : nil
    if current_link != app_dir
      Chef::Log.debug "symlinking #{app_dir} to #{app_home}"
      FileUtils.rm_f app_home
      FileUtils.ln_sf app_dir, app_home
    end
    if new_resource.bin_cmds
      new_resource.bin_cmds.each do |cmd|
        if ::File.exists? "/usr/bin/#{cmd}"
          current_bin_link = ::File.readlink("/usr/bin/#{cmd}")
        else
          current_bin_link = false
        end
        should_be_link = "#{app_home}/bin/#{cmd}"
        if current_bin_link != should_be_link
          cmd = Chef::ShellOut.new(
                                   %Q[ update-alternatives --install /usr/bin/#{cmd} #{cmd} #{app_home}/bin/#{cmd} 1;
                                       update-alternatives --set #{cmd} #{app_home}/bin/#{cmd}  ]
                                   ).run_command
          unless cmd.exitstatus == 0
            Chef::Application.fatal!(%Q[ update alternatives  failed ])
          end
        end
      end
    end
  end
end

action :remove do
  app_dir_name, tarball_name = parse_app_dir_name(new_resource.url)
  app_root = new_resource.app_home.split('/')[0..-2].join('/')
  app_dir = app_root + '/' + app_dir_name

  if ::File.exists?(app_dir)
    new_resource.bin_cmds.each do |cmd|
      cmd = execute "update_alternatives" do
        command "update-alternatives --remove #{cmd} #{app_dir} "
        returns [0,2]
        action :nothing
      end
      cmd.run_action(:run)
    end
    Chef::Log.info "Removing #{new_resource.name} at #{app_dir}"
    FileUtils.rm_rf app_dir
    new_resource.updated_by_last_action(true)
  end
end
