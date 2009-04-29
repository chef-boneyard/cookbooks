#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: server
#
# Copyright 2008-2009, Opscode, Inc
# Copyright 2009, 37signals
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

include_recipe "runit"

case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f >= 8.10
    include_recipe "couchdb"
  end
when "debian"
  if node[:platform_version].to_f >= 5.0
    include_recipe "couchdb"
  end
# when "centos","redhat","fedora"
#   include_recipe "couchdb"
end

include_recipe "stompserver" 
include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rails"
include_recipe "chef::client"

gem_package "chef-server" do
  version node[:chef][:server_version]
end

if node[:chef][:server_version] >= "0.5.7"
  gem_package "chef-server-slice" do
    version node[:chef][:server_version]
  end
end

template "/etc/chef/server.rb" do
  owner "chef"
  mode 0644
  source "server.rb.erb"
  action :create
end

directory "/var/log/chef" do
  owner "chef"
  group "chef"
  mode "775"
end

%w{ openid cache search_index openid/cstore }.each do |dir|
  directory "#{node[:chef][:path]}/#{dir}" do
    owner "chef"
    group "chef"
    mode "775"
  end
end

directory "/etc/chef/certificates" do
  owner "chef"
  group "chef"
  mode 0700
end

bash "Create SSL Certificates" do
  cwd "/etc/chef/certificates"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > chef.#{node[:domain]}.key
  openssl req -subj "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=chef.#{node[:domain]}/emailAddress=ops@#{node[:domain]}" -new -x509 -nodes -sha1 -days 3650 -key chef.#{node[:domain]}.key > chef.#{node[:domain]}.crt
  cat chef.#{node[:domain]}.key chef.#{node[:domain]}.crt > chef.#{node[:domain]}.pem
  EOH
  not_if { File.exists?("/etc/chef/certificates/chef.#{node[:domain]}.pem") }
end

runit_service "chef-indexer" 

template "#{node[:chef][:server_path]}/config.ru" do
  source "config.ru.erb"
  owner "chef"
  group "chef"
  mode "644"
  notifies :restart, resources(:service => "apache2")
end

template "#{node[:chef][:server_path]}/config/environments/production.rb" do
  source "merb-production.rb.erb"
  action :create
  owner "root"
  group "root"
  mode "664"
  notifies :restart, resources(:service => "apache2")
end

template "#{node[:chef][:server_path]}/config/init.rb" do
  source "chef-server.init.rb.erb"
  action :create
  owner "root"
  group "root"
  mode "664"
  notifies :restart, resources(:service => "apache2")
end

web_app "chef_server" do
  docroot "#{node[:chef][:server_path]}/public"
  template "chef_server.conf.erb"
  server_name "chef.#{node[:domain]}"
  server_aliases "chef"
  gems_path node[:gems_path]
  version node[:chef][:server_version]
end
