#
# Cookbook Name:: dmg
# Provider:: package
#
# Copyright 2011, Joshua Timberman
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

def load_current_resource
  @dmgpkg = Chef::Resource::DmgPackage.new(new_resource.name)
  @dmgpkg.app(new_resource.app)
  Chef::Log.debug("Checking for application #{new_resource.app}")
  installed = (new_resource.type == "app") ? (::File.directory?("#{new_resource.destination}/#{new_resource.app}.app")) : system("pkgutil --pkgs=#{new_resource.package_id}")
  @dmgpkg.installed(installed)
end

action :install do
  unless @dmgpkg.installed

    volumes_dir = new_resource.volumes_dir ? new_resource.volumes_dir : new_resource.app
    dmg_name = new_resource.dmg_name ? new_resource.dmg_name : new_resource.app
    dmg_file = "#{Chef::Config[:file_cache_path]}/#{dmg_name}.dmg"

    # Solo doesn't necessarily create the file_cache_path,
    # but we don't want to mess with it if it exists
    directory Chef::Config[:file_cache_path] do
      owner "root"
      group "admin"
      mode 0775
      action :create
      recursive true
      not_if { File.exists(Chef::Config[:file_cache_path]) }
    end

    if new_resource.source
      remote_file dmg_file do
        source new_resource.source
        checksum new_resource.checksum if new_resource.checksum
        group "admin"
        mode 0644
      end
    end
        
    ruby_block "attach #{dmg_file}" do
      block do
        software_license_agreement = system("hdiutil imageinfo #{dmg_file} | grep -q 'Software License Agreement: true'")
        confirm_mount_cmd = software_license_agreement ? "echo Y |" : ""
        system "#{confirm_mount_cmd} hdiutil attach '#{dmg_file}'"
      end
      not_if "hdiutil info | grep -q 'image-path.*#{dmg_file}'"
    end

    case new_resource.type
    when "app"
      # use "rsync -aH" instead of "cp -r" because rsync
      # won't exit(1) when it hits a bad symbolic link (e.g. Dropbox's site.py).
      execute "rsync -aH '/Volumes/#{volumes_dir}/#{new_resource.app}.app' '#{new_resource.destination}'" do
        user WS_USER
        group "admin"
      end
      file "#{new_resource.destination}/#{new_resource.app}.app/Contents/MacOS/#{new_resource.app}" do
        mode 0755
        ignore_failure true
      end
    when "mpkg"
      ruby_block "installing /Volumes/#{volumes_dir}/#{new_resource.app}.*pkg" do
        block do
          if ::File.exists?("/Volumes/#{volumes_dir}/#{new_resource.app}.mpkg")
            `sudo installer -pkg '/Volumes/#{volumes_dir}/#{new_resource.app}.mpkg' -target /`
          elsif ::File.exists?("/Volumes/#{volumes_dir}/#{new_resource.app}.pkg")
            `sudo installer -pkg '/Volumes/#{volumes_dir}/#{new_resource.app}.pkg' -target /`
          else
            raise "I couldn't find /Volumes/#{volumes_dir}/#{new_resource.app}.mpkg"
          end
        end
      end
    end

    execute "hdiutil detach '/Volumes/#{volumes_dir}'"
  end
end
