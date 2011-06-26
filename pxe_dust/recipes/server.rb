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

#search for any apt-cacher proxies
servers = search(:node, 'recipes:apt\:\:cacher') || []
if servers.length > 0
  proxy = "d-i mirror/http/proxy string http://#{servers[0].ipaddress}:3142"
else
  proxy = "#d-i mirror/http/proxy string url"
end

#loop over the other data bag items here
pxe_dust = data_bag('pxe_dust')
default = data_bag_item('pxe_dust', 'default')
pxe_dust.each do |id| 
  image = data_bag_item('pxe_dust', id)
  image_dir "#{node['tftp']['directory']}/#{id}"
  arch = image['arch'] || default['arch']
  domain = image['domain'] || default['domain']
  version = image['version'] || default['version']
  netboot_url = image['netboot_url'] || default['netboot_url']
  user_fullname = image['user']['fullname'] || default['user']['fullname']
  user_username = image['user']['username'] || default['user']['username']
  user_crypted_password = image['user']['crypted_password'] || default['user']['crypted_password']
  
  remote_file "#{image_dir}/netboot.tar.gz" do
    source netboot_url
    action :create_if_missing
  end

  execute "tar -xzf netboot.tar.gz" do
    cwd image_dir
    subscribes :run, resources(:remote_file => "#{image_dir}/netboot.tar.gz"), :immediately
    action :nothing
  end

  #skips the prompt for which installer to use
  template "#{image_dir}/pxelinux.cfg/default" do
    source "syslinux.cfg.erb"
    mode "0644"
    variables(
      :id => id,
      :arch => arch
      )
    action :create
  end

  #sets the URL to the preseed
  template "#{image_dir}/ubuntu-installer/#{arch}/boot-screens/(txt.cfg|text.cfg)"  do
    if version == 'lucid'
      path "#{image_dir}/ubuntu-installer/#{arch}/boot-screens/text.cfg"
    else
      path "#{image_dir}/ubuntu-installer/#{arch}/boot-screens/txt.cfg"
    end
    source "txt.cfg.erb"
    mode "0644"
    variables(
      :arch => arch,
      :domain => domain
      )
    action :create
  end

  template "/var/www/preseed.cfg" do
    source "preseed.cfg.erb"
    mode "0644"
    variables(
      :proxy => proxy,
      :user_fullname => user_fullname,
      :user_username => user_username,
      :user_crypted_password => user_crypted_password
      )
    action :create
  end

end

link "#{node['tftp']['directory']}/pxelinux.0" do
  to "#{node['tftp']['directory']}/default/pxelinux.0"
end

link "#{node['tftp']['directory']}/pxelinux.cfg" do
  to "#{node['tftp']['directory']}/default/pxelinux.cfg"
end

link "#{node['tftp']['directory']}/ubuntu-installer" do
  to "#{node['tftp']['directory']}/default/ubuntu-installer"
end

#bootstrap_version_string, run_list, http_proxy, http_proxy_user, http_proxy_pass, https_proxy = nil
run_list = default['run_list']
if default['bootstrap']
  bootstrap_version_string = default['bootstrap']['bootstrap_version_string'] if default['bootstrap']['bootstrap_version_string']
  http_proxy = default['bootstrap']['http_proxy'] if default['bootstrap']['http_proxy']
  http_proxy_user = default['bootstrap']['http_proxy_user'] if default['bootstrap']['http_proxy_user']
  http_proxy_pass = default['bootstrap']['http_proxy_pass'] if default['bootstrap']['http_proxy_pass']
  https_proxy = default['bootstrap']['https_proxy'] if default['bootstrap']['https_proxy']
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
    :https_proxy => https_proxy,
    :run_list => run_list
    )
  action :create
end

#link the validation_key where it can be downloaded SECURITY???
link "/var/www/validation.pem" do
  to Chef::Config[:validation_key]
end
