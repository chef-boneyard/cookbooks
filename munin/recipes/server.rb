#
# Cookbook Name:: munin
# Recipe:: server
#
# Copyright 2010-2011, Opscode, Inc.
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
node['apache']['default_modules'] << 'expires' if platform?("redhat", "centos", "scientific", "fedora")

include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "munin::client"

sysadmins = search(:users, 'groups:sysadmin')
munin_servers = search(:node, "munin:[* TO *] AND chef_environment:#{node.chef_environment}")
if munin_servers.empty?
  Chef::Log.info("No nodes returned from search, using this node so munin configuration has data")
  munin_servers = Array.new
  munin_servers << node
end

munin_servers.sort! { |a,b| a[:fqdn] <=> b[:fqdn] }

if node[:public_domain]
  case node.chef_environment
  when "production"
    public_domain = node[:public_domain]
  else
    public_domain = "#{node.chef_environment}.#{node[:public_domain]}"
  end
else
  public_domain = node[:domain]
end

case node[:platform]
when "freebsd"
  package "munin-master"
else
  package "munin"
end

case node[:platform]
when "arch"
  cron "munin-graph-html" do
    command "/usr/bin/munin-cron"
    user "munin"
    minute "*/5"
  end
when "freebsd"
  cron "munin-graph-html" do
    command "/usr/local/bin/munin-cron"
    user "munin"
    minute "*/5"
    ignore_failure true
  end
else
  cookbook_file "/etc/cron.d/munin" do
    source "munin-cron"
    mode "0644"
    owner "root"
    group node['munin']['root']['group']
    backup 0
  end
end

template "#{node['munin']['basedir']}/munin.conf" do
  source "munin.conf.erb"
  mode 0644
  variables(:munin_nodes => munin_servers, :docroot => node['munin']['docroot'])
end

case node['munin']['server_auth_method']
when "openid"
  include_recipe "apache2::mod_auth_openid"
else
  template "#{node['munin']['basedir']}/htpasswd.users" do
    source "htpasswd.users.erb"
    owner "munin"
    group node['apache']['group']
    mode 0640
    variables(
      :sysadmins => sysadmins
    )
  end
end

apache_site "000-default" do
  enable false
end

template "#{node[:apache][:dir]}/sites-available/munin.conf" do
  source "apache2.conf.erb"
  mode 0644
  variables(:public_domain => public_domain, :docroot => node['munin']['docroot'])
  if ::File.symlink?("#{node[:apache][:dir]}/sites-enabled/munin.conf")
    notifies :reload, resources(:service => "apache2")
  end
end

directory node['munin']['docroot'] do
  owner "munin"
  group "munin"
  mode 0755
end

apache_site "munin.conf"
