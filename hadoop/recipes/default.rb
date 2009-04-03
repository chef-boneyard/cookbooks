#
# Cookbook Name:: hadoop
# Recipe:: default
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

include_recipe "java"

user "hadoop" do
  shell "/bin/false"
  home "/home/hadoop"
  uid node[:hadoop][:uid]
  gid node[:hadoop][:gid]
  supports :manage_home => false
  action :create
end

remote_file "/tmp/hadoop-#{node[:hadoop][:version]}.tar.gz" do
  source "#{node[:hadoop][:mirror_url]}/hadoop-#{node[:hadoop][:version]}/hadoop-#{node[:hadoop][:version]}.tar.gz"
  not_if do FileTest.directory?("/srv/hadoop-#{node[:hadoop][:version]}") end
end

execute "tar -xzf /tmp/hadoop-#{node[:hadoop][:version]}.tar.gz" do
  cwd "/srv"
  creates "/srv/hadoop-#{node[:hadoop][:version]}"
end

link "/srv/hadoop" do
  to "/srv/hadoop-#{node[:hadoop][:version]}"
end

%w{ /etc/hadoop /etc/hadoop/env /var/log/hadoop }.each do |dir|
  directory dir 
end

%w{ hadoop-env.sh hadoop-site.xml }.each do |cfg|
  template "/etc/hadoop/#{cfg}" do
    source "#{cfg}.erb"
    owner "root"
    group "root"
    mode 0644
  end
end
  
template "/usr/bin/hadoop" do
  source "hadoop.erb"
  owner "root"
  group "root"
  mode 0755
end
