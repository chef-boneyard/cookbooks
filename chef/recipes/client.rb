#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: client
#
# Copyright 2008-2009, Opscode, Inc
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

if node[:chef][:client_log] == "STDOUT"
  client_log = node[:chef][:client_log]
  show_time  = "false"
else
  client_log = "\"#{node[:chef][:client_log]}\""
  show_time  = "true"
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/etc/chef/client.rb")
  end
  action :nothing
end

template "/etc/chef/client.rb" do
  source "client.rb.erb"
  owner "root"
  group root_group
  mode "644"
  variables(
    :client_log => client_log,
    :show_time  => show_time
  )
  notifies :create, resources(:ruby_block => "reload_client_config")
end

execute "Register client node with Chef Server" do
  command "/usr/bin/env chef-client -t \`cat /etc/chef/validation_token\`"
  only_if { File.exists?("/etc/chef/validation_token") }
  not_if  { File.exists?("#{node[:chef][:path]}/cache/registration") }
end

execute "Remove the validation token" do
  command "rm /etc/chef/validation_token"
  only_if { File.exists?("/etc/chef/validation_token") }
end
