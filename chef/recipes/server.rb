#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: server
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

include_recipe "chef::client"

service "chef-indexer" do
  action :nothing
end

service "chef-server" do
  action :nothing
  if node[:chef][:init_style] == "runit"
    restart_command "sv int chef-server"
  end
end

if node[:chef][:server_log] == "STDOUT"
  server_log = node[:chef][:server_log]
  show_time  = "false"
else
  server_log = "\"#{node[:chef][:server_log]}\""
  show_time  = "true"
end

template "/etc/chef/server.rb" do
  source "server.rb.erb"
  owner "root"
  group root_group
  mode "644"
  variables(
    :server_log => server_log,
    :show_time  => show_time
  )
  notifies :restart, resources(
    :service => "chef-indexer",
    :service => "chef-server"
  ), :delayed
end

http_request "compact chef couchDB" do
  action :post
  url "http://localhost:5984/chef/_compact"
  only_if do
    begin
      open("#{Chef::Config[:couchdb_url]}/chef")
      JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef").read)["disk_size"] > 100_000_000
    rescue OpenURI::HTTPError
      nil
    end
  end
end
