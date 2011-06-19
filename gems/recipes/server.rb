#
# Cookbook Name:: gems
# Recipe:: server
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

include_recipe "apache2"

gem_package "builder" do
  action :install
end

template "#{node[:apache][:dir]}/sites-available/gem_server.conf" do
  source "gem_server.conf.erb"
  variables(
    :virtual_host_name => node[:gem_server][:virtual_host_name],
    :virtual_host_alias => node[:gem_server][:virtual_host_alias],
    :gem_directory => node[:gem_server][:directory]
  )
  owner "root"
  mode 0755
end

apache_site "gem_server.conf"

execute "index-gem-repository" do
  command "gem generate_index -d #{node[:gem_server][:directory]}"
  action :nothing
end

directory "#{node[:gem_server][:directory]}" do
  owner "root"
  group "root"
  mode 0755
end

remote_directory "#{node[:gem_server][:directory]}/gems" do
  source "packages"
  owner "root"
  group "root"
  mode "755"
  notifies :run, resources(:execute => "index-gem-repository")
end
