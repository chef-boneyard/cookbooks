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

#get the 'pxe_dust' data bag
defaults = data_bag_item('pxe_dust', 'defaults')

execute "tar -xzf netboot.tar.gz" do
  cwd node['tftp']['directory']
  action :nothing
end

remote_file "#{node['tftp']['directory']}/netboot.tar.gz" do
  source "http://archive.ubuntu.com/ubuntu/dists/#{defaults['version']}/main/installer-#{defaults['arch']}/current/images/netboot/netboot.tar.gz"
  notifies :run, resources(:execute => "tar -xzf netboot.tar.gz"), :immediate
  action :create_if_missing
end

#skips the prompt for which installer to use
template "#{node['tftp']['directory']}/pxelinux.cfg/default" do
  source "syslinux.cfg.erb"
  mode "0644"
  variables(
      :arch => defaults['arch']
  )
  action :create
end

#sets the URL to the preseed
template "#{node['tftp']['directory']}/ubuntu-installer/#{defaults['arch']}/boot-screens/(txt.cfg|text.cfg)"  do
  if defaults['version'] == 'lucid'
    path "#{node['tftp']['directory']}/ubuntu-installer/#{defaults['arch']}/boot-screens/text.cfg"
  else
    path "#{node['tftp']['directory']}/ubuntu-installer/#{defaults['arch']}/boot-screens/txt.cfg"
  end
  source "txt.cfg.erb"
  mode "0644"
  variables(
      :arch => defaults['arch']
  )
  action :create
end

#search for any apt-cacher proxies
servers = search(:node, 'recipes:apt\:\:cacher') || []
if servers.length > 0
  proxy = "d-i mirror/http/proxy string http://#{servers[0].ipaddress}:3142"
  run_list = "recipe[apt::cacher-client]"
else
  proxy = "#d-i mirror/http/proxy string url"
  run_list = ""
end
template "/var/www/preseed.cfg" do
  source "preseed.cfg.erb"
  mode "0644"
  variables(
      :proxy => proxy,
      :user_fullname => defaults['user']['fullname'],
      :user_username => defaults['user']['username'],
      :user_crypted_password => defaults['user']['crypted_password']
  )
  action :create
end

bootstrap_version_string = ""
http_proxy, http_proxy_user, http_proxy_pass, https_proxy = nil
if defaults['bootstrap']
  bootstrap_version_string = defaults['bootstrap']['bootstrap_version_string'] if defaults['bootstrap']['bootstrap_version_string']
  http_proxy = defaults['bootstrap']['http_proxy'] if defaults['bootstrap']['http_proxy']
  http_proxy_user = defaults['bootstrap']['http_proxy_user'] if defaults['bootstrap']['http_proxy_user']
  http_proxy_pass = defaults['bootstrap']['http_proxy_pass'] if defaults['bootstrap']['http_proxy_pass']
  https_proxy = defaults['bootstrap']['https_proxy'] if defaults['bootstrap']['https_proxy']
end

#Chef bootstrap script run by new installs
template "/var/www/chef-bootstrap" do
  source "chef-bootstrap.sh.erb"
  mode "0644"
  variables(
      :bootstrap_version_string => bootstrap_version_string,
      :http_proxy => http_proxy,
      :http_proxy_user => http_proxy_user,
      :http_proxy_pass => http_proxy_pass,
      :https_proxy => https_proxy
  )
  action :create
end

#link the validation_key where it can be downloaded SECURITY??? 
link "/var/www/validation.pem" do
  to Chef::Config[:validation_key]
end
