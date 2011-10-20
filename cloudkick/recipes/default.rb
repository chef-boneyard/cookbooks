#
# Cookbook Name:: cloudkick
# Recipe:: default
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

case node['platform']
when "ubuntu"
  apt_repository "cloudkick" do
    uri "http://packages.cloudkick.com/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://packages.cloudkick.com/cloudkick.packages.key"
    action :add
  end
when "centos", "redhat"
  yum_repository "cloudkick" do
    url "http://packages.cloudkick.com/redhat/$basearch"
    action :add
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
    :node_name => node.name,
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

gem_package "cloudkick" do
  action :install
end

ruby_block "cloudkick data load" do
  block do
    Gem.clear_paths
    require 'cloudkick'
    node.set['cloudkick']['data'] = Chef::CloudkickData.get(node)
  end
  action :create
end