#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: php
# Recipe:: php5-cgi
#
# Copyright 2009, Opscode, Inc.
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

#include_recipe "apache2"
include_recipe "php::module_mysql"
include_recipe "php::module_sqlite3"
include_recipe "php::module_memcache"
include_recipe "php::module_gd"
include_recipe "php::module_pgsql"

case node[:platform]
  when "centos", "redhat", "fedora", "suse"
    #placeholder modify when available
  when "debian", "ubuntu"
    package "php5-cgi" do
      action :upgrade
    end
end

user "www-data" do
  uid "33"
  gid "www-data"
  shell "/bin/true"
  home "/var/www"
end

service "php-cgi" do
  supports :restart => true , :start => true, :stop => true
  action :nothing
end


memcache_servers = search(:node, "recipes:memcached AND cluster_environment:#{node[:cluster][:environment]}")
template value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "/etc/php.ini"}, "default" => "/etc/php5/cgi/php.ini") do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
  variables :memcache_servers => memcache_servers
  notifies :restart, resources(:service => "php-cgi"), :delayed
end

template "/etc/init.d/php-cgi" do
  source "spawn-php-cgi.erb"
  mode "0755"
  notifies :restart, resources(:service => "php-cgi"), :immediately
end

service "php-cgi" do
  running true
  supports :restart => true , :start => true, :stop => true, :reload => false
  enabled true
  action [ :enable, :start ]
end
