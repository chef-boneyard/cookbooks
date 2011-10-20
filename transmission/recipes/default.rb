#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: transmission
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
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

include_recipe "transmission::#{node['transmission']['install_method']}"

# Install gems required by LWRP in advance
# activesupport 3+ won't run under Ruby 1.8.6
r = gem_package "activesupport" do
  version '2.3.11'
  action :nothing
end
r.run_action(:install)
%w{bencode i18n transmission-simple}.each do |pkg|
  r = gem_package pkg do
    action :nothing
  end
  r.run_action(:install)
end
require 'rubygems'
Gem.clear_paths
require 'transmission-simple'

template "transmission-default" do
  case node['platform']
  when "centos","redhat" 
    path "/etc/sysconfig/transmission-daemon"
  else 
    path "/etc/default/transmission-daemon"
  end
  source "transmission-daemon.default.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/init.d/transmission-daemon" do
  source "transmission-daemon.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "transmission" do
  service_name "transmission-daemon"
  supports :restart => true, :reload => true
  action [:enable, :start]
end

directory "/etc/transmission-daemon" do
  owner "root"
  group node['transmission']['group']
  mode "755"
end

template "#{node['transmission']['config_dir']}/settings.json" do
  source "settings.json.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[transmission]", :immediate
end

link "/etc/transmission-daemon/settings.json" do
  to "#{node['transmission']['config_dir']}/settings.json"
end
