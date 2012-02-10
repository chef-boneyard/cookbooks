# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: pxe_dust
# Recipe:: server
#
# Copyright 2011, 2012 Opscode, Inc
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

#search for any apt-cacher-ng caching proxies
servers = search(:node, 'recipes:apt\:\:cacher-ng') || []
if servers.length > 0
  proxy = "d-i mirror/http/proxy string http://#{servers[0].ipaddress}:3142"
else
  proxy = "#d-i mirror/http/proxy string url"
end

directory "#{node['tftp']['directory']}/pxelinux.cfg" do
  mode "0755"
end

#location of the full stack installers
directory "/var/www/opscode-full-stack" do
  mode "0755"
end

#for getting latest version of full stack installers
remote_file "/var/www/opscode-full-stack/install.sh" do
  source "http://opscode.com/chef/install.sh"
end
ruby_block "chef version" do
  block do
    cmd = Chef::ShellOut.new("grep release_version /var/www/opscode-full-stack/install.sh")
    output = cmd.run_command
    node['pxe_dust']['chefversion'] = output.stdout.split('"')[1]
  end
end

#loop over the other data bag items here
pxe_dust = data_bag('pxe_dust')
default = data_bag_item('pxe_dust', 'default')
pxe_dust.each do |id|
  image = data_bag_item('pxe_dust', id)
  image_dir = "#{node['tftp']['directory']}/#{id}"
  arch = image['arch'] || default['arch']
  domain = image['domain'] || default['domain']
  version = image['version'] || default['version']
  netboot_url = image['netboot_url'] || default['netboot_url']
  run_list = image['run_list']
  if image['user']
    user_fullname = image['user']['fullname']
    user_username = image['user']['username']
    user_crypted_password = image['user']['crypted_password']
  elsif default['user']
    user_fullname = default['user']['fullname']
    user_username = default['user']['username']
    user_crypted_password = default['user']['crypted_password']
  end
  if image['root']
    root_crypted_password = image['root']['crypted_password']
  elsif default['root']
    root_crypted_password = default['root']['crypted_password']
  end
  if image['bootstrap']
    http_proxy = image['bootstrap']['http_proxy']
    http_proxy_user = image['bootstrap']['http_proxy_user']
    http_proxy_pass = image['bootstrap']['http_proxy_pass']
    https_proxy = image['bootstrap']['https_proxy']
  elsif default['bootstrap']
    http_proxy = default['bootstrap']['http_proxy']
    http_proxy_user = default['bootstrap']['http_proxy_user']
    http_proxy_pass = default['bootstrap']['http_proxy_pass']
    https_proxy = default['bootstrap']['https_proxy']
  end

  directory image_dir do
    mode "0755"
  end

  #local mirror for netboots
  remote_file "/var/www/#{id}-netboot.tar.gz" do
    source netboot_url
    action :create_if_missing
  end

  execute "tar -xzf /var/www/#{id}-netboot.tar.gz" do
    cwd image_dir
    subscribes :run, resources(:remote_file => "/var/www/#{id}-netboot.tar.gz"), :immediately
    action :nothing
  end

  link "#{node['tftp']['directory']}/pxe-#{id}.0" do
    to "#{id}/pxelinux.0"
  end

  if image['addresses']
    mac_addresses = image['addresses'].keys
  else
    mac_addresses = []
  end

  # only get the full stack installers in use
  case version
  when "10.04","10.10"
    platform = "ubuntu"
    if arch.eql?("i386")
      release = "ubuntu-10.04-i686"
    elsif arch.eql?("amd64")
      release = "ubuntu-10.04-x86_64"
    end
  when "11.04","11.10"
    platform = "ubuntu"
    if arch.eql?("i386")
      release = "ubuntu-11.04-i686"
    elsif arch.eql?("amd64")
      release = "ubuntu-11.04-x86_64"
    end
  when "6.0.4"
    platform = "debian"
    if arch.eql?("i386")
      release = "debian-6.0.1-i686"
    elsif arch.eql?("amd64")
      release = "debian-6.0.1-x86_64"
    end
  end

  directory "/var/www/opscode-full-stack/#{release}" do
    mode "0755"
  end

  installer = "chef-full_#{node['pxe_dust']['chefversion']}_#{arch}.deb"

  #download the full stack installer
  remote_file "/var/www/opscode-full-stack/#{release}/#{installer}" do
    source "http://s3.amazonaws.com/opscode-full-stack/#{release}/#{installer}"
    mode "0644"
    action :create_if_missing
  end

  mac_addresses.each do |mac_address|
    mac = mac_address.gsub(/:/, '-')
    mac.downcase!
    template "#{node['tftp']['directory']}/pxelinux.cfg/01-#{mac}" do
      source "pxelinux.cfg.erb"
      mode "0644"
      variables(
        :platform => platform,
        :id => id,
        :arch => arch,
        :domain => domain
        )
      action :create
    end
  end



  template "/var/www/#{id}-preseed.cfg" do
    source "#{platform}-preseed.cfg.erb"
    mode "0644"
    variables(
      :id => id,
      :proxy => proxy,
      :user_fullname => user_fullname,
      :user_username => user_username,
      :user_crypted_password => user_crypted_password,
      :root_crypted_password => root_crypted_password
      )
    action :create
  end


  #Chef bootstrap script run by new installs
  template "/var/www/#{id}-chef-bootstrap" do
    source "chef-bootstrap.sh.erb"
    mode "0644"
    variables(
      :release => release,
      :installer => installer,
      :http_proxy => http_proxy,
      :http_proxy_user => http_proxy_user,
      :http_proxy_pass => http_proxy_pass,
      :https_proxy => https_proxy,
      :run_list => run_list
      )
    action :create
  end

end

#configure the defaults
link "#{node['tftp']['directory']}/pxelinux.0" do
  to "default/pxelinux.0"
end

template "#{node['tftp']['directory']}/pxelinux.cfg/default"  do
  source "pxelinux.cfg.erb"
  mode "0644"
  variables(
    :platform => default['platform'],
    :id => 'default',
    :arch => default['arch'],
    :domain => default['domain']
    )
  action :create
end

#link the validation_key where it can be downloaded
link "/var/www/validation.pem" do
  to Chef::Config[:validation_key]
end
