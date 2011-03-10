#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: client
#
# Copyright 2008-2010, Opscode, Inc
# Copyright 2009, 37signals
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

chef_node_name = Chef::Config[:node_name] == node["fqdn"] ? nil : Chef::Config[:node_name]

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/etc/chef/client.rb")
  end
  action :nothing
end

cookbook_file "/etc/chef/nagios_handler.rb" do
  owner "root"
  group root_group
  mode "644"
  only_if { node.recipe? "nagios::nsca-client" }
  notifies :create, resources(:ruby_block => "reload_client_config")
end

template "/etc/chef/client.rb" do
  source "client.rb.erb"
  owner "root"
  group root_group
  mode "644"
  variables :chef_node_name => chef_node_name
  notifies :create, resources(:ruby_block => "reload_client_config")
end

log "Add the chef::delete_validation recipe to the run list to remove the #{Chef::Config[:validation_key]}." do
  only_if { ::File.exists?(Chef::Config[:validation_key]) }
end
