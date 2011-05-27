#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: server
#
# Copyright 2009, 37signals
# Copyright 2009-2011, Opscode, Inc
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

include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rewrite"
include_recipe "nagios::client"

sysadmins = search(:users, 'groups:sysadmin')
nodes = search(:node, "hostname:[* TO *] AND chef_environment:#{node.chef_environment}")

if nodes.empty?
  Chef::Log.info("No nodes returned from search, using this node so hosts.cfg has data")
  nodes = Array.new
  nodes << node
end

members = Array.new
sysadmins.each do |s|
  members << s['id']
end

role_list = Array.new
service_hosts= Hash.new
search(:role, "*:*") do |r|
  role_list << r.name
  search(:node, "role:#{r.name} AND chef_environment:#{node.chef_environment}") do |n|
    service_hosts[r.name] = n['hostname']
  end
end

if node['public_domain']
  public_domain = node['public_domain']
else
  public_domain = node['domain']
end

include_recipe "nagios::server_#{node['nagios']['server']['install_method']}"

service "nagios" do
  service_name node['nagios']['server']['service_name']
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

nagios_conf "nagios" do
  config_subdir false
end

directory "#{node['nagios']['conf_dir']}/dist" do
  owner node['nagios']['user']
  group node['nagios']['group']
  mode "0755"
end

directory node['nagios']['state_dir'] do
  owner node['nagios']['user']
  group node['nagios']['group']
  mode "0751"
end

directory "#{node['nagios']['state_dir']}/rw" do
  owner node['nagios']['user']
  group node['apache']['user']
  mode "2710"
end

execute "archive-default-nagios-object-definitions" do
  command "mv #{node['nagios']['config_dir']}/*_nagios*.cfg #{node['nagios']['conf_dir']}/dist"
  not_if { Dir.glob("#{node['nagios']['config_dir']}/*_nagios*.cfg").empty? }
end

file "#{node['apache']['dir']}/conf.d/nagios3.conf" do
  action :delete
end

case node['nagios']['server_auth_method']
when "openid"
  include_recipe "apache2::mod_auth_openid"
else
  template "#{node['nagios']['conf_dir']}/htpasswd.users" do
    source "htpasswd.users.erb"
    owner node['nagios']['user']
    group node['apache']['user']
    mode 0640
    variables(
      :sysadmins => sysadmins
    )
  end
end

apache_site "000-default" do
  enable false
end

template "#{node['apache']['dir']}/sites-available/nagios3.conf" do
  source "apache2.conf.erb"
  mode 0644
  variables :public_domain => public_domain
  if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/nagios3.conf")
    notifies :reload, "service[apache2]"
  end
end

apache_site "nagios3.conf"

%w{ nagios cgi }.each do |conf|
  nagios_conf conf do
    config_subdir false
  end
end

%w{ commands templates timeperiods}.each do |conf|
  nagios_conf conf
end

nagios_conf "services" do
  variables :service_hosts => service_hosts
end

nagios_conf "contacts" do
  variables :admins => sysadmins, :members => members
end

nagios_conf "hostgroups" do
  variables :roles => role_list
end

nagios_conf "hosts" do
  variables :nodes => nodes
end
