#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef
# Recipe:: bootstrap_client
#
# Copyright 2009-2010, Opscode, Inc.
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

gem_package "chef" do
  version node[:chef][:client_version]
end

case node[:chef][:init_style]
when "runit"
  client_log = node[:chef][:client_log]
  show_time  = "false"
  include_recipe "runit"
  runit_service "chef-client"
when "init"
  client_log = "\"#{node[:chef][:client_log]}\""
  show_time  = "true"

  directory node[:chef][:run_path] do
    action :create
    owner "root"
    group root_group
    mode "755"
  end

  service "chef-client" do
    action :nothing
  end

  log("You specified service style 'init'.")
  log("'init' scripts available in #{node[:languages][:ruby][:gems_dir]}/gems/chef-#{node[:chef][:client_version]}/distro")
when "bsd"
  client_log = node[:chef][:client_log]
  show_time  = "false"
  log("You specified service style 'bsd'. You will need to set up your rc.local file.")
  log("Hint: chef-client -i #{node[:chef][:client_interval]} -s #{node[:chef][:client_splay]}")
else
  client_log = node[:chef][:client_log]
  show_time  = "false"
  log("Could not determine service init style, manual intervention required to start up the client service.")
end

chef_dirs = [
  node[:chef][:log_dir],
  node[:chef][:path],
  "/etc/chef"
]

chef_dirs.each do |dir|
  directory dir do
    owner "root"
    group root_group
    mode "755"
  end
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
end
