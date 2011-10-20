# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: pxe_dust
# Recipe:: server
#
# Copyright 2011, Opscode, Inc
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

include_recipe "apache2"

include_recipe "tftp::server"

execute "tar -xzf netboot.tar.gz" do
  cwd node[:tftp][:directory]
  action :nothing
end

remote_file "#{node[:tftp][:directory]}/netboot.tar.gz" do
  source "http://archive.ubuntu.com/ubuntu/dists/#{node[:pxe_dust][:version]}/main/installer-#{node[:pxe_dust][:arch]}/current/images/netboot/netboot.tar.gz"
  notifies :run, resources(:execute => "tar -xzf netboot.tar.gz"), :immediate
  action :create_if_missing
end

#skips the prompt for which installer to use
template "#{node[:tftp][:directory]}/pxelinux.cfg/default" do
  source "syslinux.cfg.erb"
  mode "0644"
  action :create
end

#sets the URL to the preseed
template "#{node[:tftp][:directory]}/ubuntu-installer/#{node[:pxe_dust][:arch]}/boot-screens/(txt.cfg|text.cfg)"  do
  if node[:pxe_dust][:version] == 'lucid'
    path "#{node[:tftp][:directory]}/ubuntu-installer/#{node[:pxe_dust][:arch]}/boot-screens/text.cfg"
  else
    path "#{node[:tftp][:directory]}/ubuntu-installer/#{node[:pxe_dust][:arch]}/boot-screens/txt.cfg"
  end
  source "txt.cfg.erb"
  mode "0644"
  action :create
end

#search for any apt-cacher proxies
servers = search(:node, 'recipes:apt\:\:cacher') || []
if servers.length > 0
  proxy = "d-i mirror/http/proxy string http://#{servers[0].ipaddress}:3142"
else
  proxy = "#d-i mirror/http/proxy string url"
end
template "/var/www/preseed.cfg" do
  source "preseed.cfg.erb"
  mode "0644"
  variables({
              :proxy => proxy
            })
  action :create
end
