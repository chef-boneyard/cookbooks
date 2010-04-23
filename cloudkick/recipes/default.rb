#
# Cookbook Name:: cloudkick
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

case node.platform
when "ubuntu" 
  include_recipe "apt"
 
  package "curl"

  execute "curl http://packages.cloudkick.com/cloudkick.packages.key | apt-key add -" do
    not_if "apt-key finger | grep '0B80 27BD B5FB A7F1 8FF3  DC1F 2B5E 7CE0 8EE6 154E'"
  end

  template "/etc/apt/sources.list.d/cloudkick.com.list" do
    mode "0644"
    source "cloudkick.com.list.erb"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
when "centos", "redhat"
  execute "yum check-update" do
    action :nothing
  end

  template "/etc/yum.repos.d/cloudkick.repo" do
    mode "0644"
    source "cloudkick.repo.erb"
    notifies :run, resources(:execute => "yum check-update"), :immediately
  end
end

remote_directory "/usr/lib/cloudkick-agent/plugins" do
  source "plugins"
  mode "0755"
  files_mode "0755"
  files_backup 0
  recursive true
end

template "/etc/cloudkick.conf" do
  mode "0644"
  source "cloudkick.conf.erb"
  variables({
    :cloudkick_tags => node.run_list.roles
  })
end

package "cloudkick-agent" do
  action :upgrade
end

service "cloudkick-agent" do
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/cloudkick.conf")
end

ruby_block "initial cloudkick data load" do
  block do
    Gem.clear_paths
    require 'cloudkick'
    node.set[:cloudkick][:data] = Chef::CloudkickData.get(node)
  end
  action :nothing
end

gem_package "cloudkick" do
  notifies :create, resources(:ruby_block => "initial cloudkick data load"), :immediately
end

