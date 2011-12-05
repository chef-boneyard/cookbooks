#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Provider:: java
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
  app_dir = new_resource.app_root + '/' + app_dir_name

  if new_resource.default
    app_home = new_resource.app_root + '/' + "default"
  else
    app_home = app_dir
  end
  
  unless ::File.exists?(app_dir)
    Chef::Log.info "Adding #{new_resource.name} to #{app_dir}"

    puts "app_root is #{new_resource.app_root}"
    unless ::File.exists?(new_resource.app_root)
      FileUtils.mkdir new_resource.app_root, :mode => new_resource.app_root_mode
      FileUtils.chown new_resource.owner, new_resource.owner, new_resource.app_root
    end

    puts "cache location is #{Chef::Config[:file_cache_path]}/#{tarball_name}"
    puts "checksum is #{new_resource.checksum} "
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
      %x[ cd "#{tmpdir}";
          cp "#{Chef::Config[:file_cache_path]}/#{tarball_name}" . ;
          bash ./#{tarball_name} -noregister
        ]
    when /^.*\.zip/
      %x[ unzip "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -d "#{tmpdir}" ]
    when /^.*\.tar.gz/
      puts "now we're extracting #{tarball_name} to #{tmpdir}"
      %x[ tar xvzf "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -C "#{tmpdir}" ]
    end

    if new_resource.default
      FileUtils.mv "#{tmpdir}/#{app_dir_name}", app_dir
    else
      FileUtils.mv "#{tmpdir}/#{app_dir_name}", "#{app_dir}_alt"
    end
    FileUtils.rm_r tmpdir

    #update-alternatives
    if new_resource.default
      FileUtils.rm_f app_home
      FileUtils.ln_s app_dir, app_home, :force => true
      if new_resource.bin_cmds
        new_resource.bin_cmds.each do |cmd|
          %x[ update-alternatives --install /usr/bin/#{cmd} #{cmd} #{app_home}/bin/#{cmd} 1;
              update-alternatives --set #{cmd} #{app_home}/bin/#{cmd}  ]
        end
      end
    end
  end
end

action :remove do
  app_dir_name, tarball_name = parse_app_dir_name(new_resource.url)
  app_dir = new_resource.app_root + '/' + app_dir_name
  
  if ::File.exists?(app_dir)
    Chef::Log.info "Removing #{new_resource.name} at #{app_dir}"
    FileUtils.rm_rf app_dir
    new_resource.bin_cmds.each do |cmd|
      execute "update_alternatives" do
        command "update-alternatives --remove #{cmd} #{app_dir} "
      end
    end 
    new_resource.updated_by_last_action(true)
  end
end
