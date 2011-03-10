#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Cookbook Name:: nagios
# Recipe:: server
#
# Copyright 2009, 37signals
# Copyright 2009-2010, Opscode, Inc
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

contacts = search(:users, "groups:(#{node[:nagios][:contact_groups].join(" ")})")
nodes = search(:node, "hostname:[* TO *] AND cluster_environment:#{node[:cluster][:environment]} AND nagios_monitored:true")
default_gw = `route -n | grep ^0.0.0.0 | awk \'{print \$2}\'`
groups = contacts.map{|c| c['groups']}.flatten.uniq

if nodes.empty?
  Chef::Log.info("No nodes returned from search, using this node so hosts.cfg has data")
  nodes = Array.new
  nodes << node
end

role_list = search(:role, "*:*").map{|r| r.name}
service_hosts = nodes.inject(Hash.new) do |role_hosts, n|
  n.roles.each do |r|
    if role_hosts.has_key? r
      role_hosts[r].push n
    else
      role_hosts[r] = [n]
    end
  end
  role_hosts
end
if node[:public_domain]
  public_domain = node[:public_domain]
else
  public_domain = node[:domain]
end

%w{ nagios3 nagios-nrpe-plugin nagios-images }.each do |pkg|
  package pkg
end

service "nagios3" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

nagios_conf "nagios" do
  restart true
  config_subdir false
end

directory "#{node[:nagios][:dir]}/dist" do
  owner "nagios"
  group "nagios"
  mode "0755"
end

directory node[:nagios][:state_dir] do
  owner "nagios"
  group "nagios"
  mode "0751"
end

directory "#{node[:nagios][:state_dir]}/rw" do
  owner "nagios"
  group node[:apache][:user]
  mode "2710"
end

execute "archive default nagios object definitions" do
  command "mv #{node[:nagios][:dir]}/conf.d/*_nagios*.cfg #{node[:nagios][:dir]}/dist"
  not_if { Dir.glob(node[:nagios][:dir] + "/conf.d/*_nagios*.cfg").empty? }
end

file "#{node[:apache][:dir]}/conf.d/nagios3.conf" do
  action :delete
end

case node[:nagios][:server_auth_method]
when "openid"
  include_recipe "apache2::mod_auth_openid"
else
  template "#{node[:nagios][:dir]}/htpasswd.users" do
    source "htpasswd.users.erb"
    owner "nagios"
    group node[:apache][:user]
    mode 0640
    variables(
      :contacts => contacts
    )
  end
end

apache_site "000-default" do
  enable false
end

template "#{node[:apache][:dir]}/sites-available/nagios3.conf" do
  source "apache2.conf.erb"
  mode 0644
  variables :public_domain => public_domain
  if ::File.symlink?("#{node[:apache][:dir]}/sites-enabled/nagios3.conf")
    notifies :reload, resources(:service => "apache2")
  end
end

apache_site "nagios3.conf"

%w{ nagios cgi }.each do |conf|
  nagios_conf conf do
    config_subdir false
  end
end

%w{ commands templates timeperiods escalations}.each do |conf|
  nagios_conf conf
end

nagios_conf "services" do
  variables :service_hosts => service_hosts
end

nagios_conf "contacts" do
  variables :contacts => contacts, :groups => groups
end

nagios_conf "hostgroups" do
  variables :roles => role_list
end

nagios_conf "hosts" do
  variables :nodes => nodes, :default_gw => default_gw
end

cookbook_file ::File.join(node[:nagios][:dir], node[:nagios][:config_subdir], "external.cfg") do
  ignore_failure true
  owner "nagios"
  group "nagios"
  mode "0644"
  notifies :reload, 'service[nagios3]'
end

cookbook_file "/usr/bin/sms" do
  source "clickatell-sms.py"
  mode "0755"
end

node[:nagios][:monitored] = true
provide_service("monitoring")
