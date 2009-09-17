#
# Author:: Daniel DeLeo <dan@kallistec.com>
# Cookbook Name:: subversion
# Recipe:: server
#
# Copyright 2009, Daniel DeLeo
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
include_recipe "apache2::mod_dav_svn"
include_recipe "subversion::client"

directory node[:subversion][:repo_dir] do
  recursive true
  owner node[:apache][:user]
  group node[:apache][:user]
  mode "0755"
end

web_app "subversion" do
  template "subversion.conf.erb"
  server_name "#{node[:subversion][:server_name]}.#{node[:domain]}"
  notifies :restart, resources(:service => "apache2")
end

execute "svnadmin create repo" do
  command "svnadmin create #{node[:subversion][:repo_dir]}/#{node[:subversion][:repo_name]}"
  creates "#{node[:subversion][:repo_dir]}/#{node[:subversion][:repo_name]}"
  user node[:apache][:user]
  group node[:apache][:user]
end

execute "create htpasswd file" do
  command "htpasswd -scb #{node[:subversion][:repo_dir]}/htpasswd #{node[:subversion][:user]} #{node[:subversion][:password]}"
  creates "#{node[:subversion][:repo_name]}/htpasswd"
end
