#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
#
# Cookbook Name:: bootstrap
# Recipe:: server
#
# Copyright 2009, Opscode, Inc.
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
#

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

include_recipe "bootstrap::client"

case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f >= 9.10
    include_recipe "couchdb"
  elsif node[:platform_version].to_f >= 8.10
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "rabbitmq_chef"

when "debian"
  if node[:platform_version] =~ /.*sid/
    include_recipe "couchdb"
  else
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "rabbitmq_chef"

when "centos","redhat","fedora"
  include_recipe "java"
  include_recipe "couchdb"
  include_recipe "rabbitmq_chef"
else
  Chef::Log.info("Unknown platform for CouchDB. Manual installation of CouchDB required.")
  Chef::Log.info("Unknown platform for RabbitMQ. Manual installation of RabbitMQ required.")
  Chef::Log.info("Unknown platform for Java. Manual installation of Java required.")
  Chef::Log.info("Components that rely on these packages being installed may fail to start.")
end

include_recipe "zlib"
include_recipe "xml"

%w{ chef-server chef-server-api chef-solr }.each do |gem|
  gem_package gem do
    version node[:bootstrap][:chef][:server_version]
  end
end

if node[:bootstrap][:chef][:webui_enabled]
  gem_package "chef-server-webui" do
    version node[:bootstrap][:chef][:server_version]
  end
end

if node[:bootstrap][:chef][:server_log] == "STDOUT"
  server_log = node[:bootstrap][:chef][:server_log]
  show_time  = "false"
else
  server_log = "\"#{node[:bootstrap][:chef][:server_log]}\""
  indexer_log = "\"#{node[:bootstrap][:chef][:indexer_log]}\""
  show_time  = "true"
end

template "/etc/chef/server.rb" do
  source "server.rb.erb"
  owner "root"
  group root_group
  mode "600"
  variables(
    :server_log => server_log,
    :show_time  => show_time
  )
end

%w{ cache search_index }.each do |dir|
  directory "#{node[:bootstrap][:chef][:path]}/#{dir}" do
    owner "root"
    group root_group
    mode "755"
  end
end

directory "/etc/chef/certificates" do
  owner "root"
  group root_group
  mode "700"
end

directory node[:bootstrap][:chef][:run_path] do
  owner "root"
  group root_group
  mode "755"
end

case node[:bootstrap][:chef][:init_style]
when "runit"
  include_recipe "runit"
  runit_service "chef-solr"
  runit_service "chef-solr-indexer"
  runit_service "chef-server"
  service "chef-server" do
    restart_command "sv int chef-server"
  end
  runit_service "chef-server-webui" if node[:bootstrap][:chef][:webui_enabled]
when "init"
  show_time  = "true"

  service "chef-solr" do
    action :nothing
  end

  service "chef-solr-indexer" do
    action :nothing
  end

  service "chef-server" do
    action :nothing
  end

  service "chef-server-webui" do
    action :nothing
  end if node[:bootstrap][:chef][:webui_enabled]

  Chef::Log.info("You specified service style 'init'.")
  Chef::Log.info("'init' scripts available in #{node[:languages][:ruby][:gems_dir]}/gems/chef-#{node[:bootstrap][:chef][:client_version]}/distro")
when "bsd"
  Chef::Log.info("You specified service style 'bsd'. You will need to set up your rc.local file for chef-indexer and chef-server.")
  Chef::Log.info("Server startup command: chef-server -d")
else
  Chef::Log.info("Could not determine service init style, manual intervention required to set up indexer and server services.")
end
