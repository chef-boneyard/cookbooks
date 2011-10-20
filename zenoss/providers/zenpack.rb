#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Provider:: zenpack
#
# Copyright 2010, 2011 Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :install do
  unless @zenpack.exists
    zpfile = "#{new_resource.package}-#{new_resource.version}-#{new_resource.py_version}.egg"
    Chef::Log.info "Installing the #{zpfile} ZenPack."
    #download the ZenPack
    remote_file "/tmp/#{zpfile}" do
      source "http://dev.zenoss.com/zenpacks/#{zpfile}"
      mode "0644"
      action :create
    end
    #install the ZenPack
    execute "zenpack --install" do
      user "zenoss"
      cwd "/tmp"
      environment ({
                     'LD_LIBRARY_PATH' => "#{node[:zenoss][:server][:zenhome]}/lib",
                     'PYTHONPATH' => "#{node[:zenoss][:server][:zenhome]}/lib/python",
                     'ZENHOME' => node[:zenoss][:server][:zenhome]
                   })
      command "#{node[:zenoss][:server][:zenhome]}/bin/zenpack --install=#{zpfile}"
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  if @zenpack.exists
    Chef::Log.info "Removing the #{new_resource.package} ZenPack."
    execute "zenpack --remove" do
      user "zenoss"
      environment ({
                     'LD_LIBRARY_PATH' => "#{node[:zenoss][:server][:zenhome]}/lib",
                     'PYTHONPATH' => "#{node[:zenoss][:server][:zenhome]}/lib/python",
                     'ZENHOME' => node[:zenoss][:server][:zenhome]
                   })
      command "#{node[:zenoss][:server][:zenhome]}/bin/zenpack --remove=#{new_resource.package}"
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

#check if the zenpack is already installed
def load_current_resource
  @zenpack = Chef::Resource::ZenossZenpack.new(new_resource.package)
  Chef::Log.debug("Checking for ZenPack #{new_resource.name}")
  zp = shell_out("sudo -u zenoss -i #{node[:zenoss][:server][:zenhome]}/bin/zenpack --list")
  exists = zp.stdout.include?(new_resource.package)
  @zenpack.exists(exists)
end
