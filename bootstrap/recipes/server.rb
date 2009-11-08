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

CHEF_08_GEMS_RELEASED = false

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

include_recipe "bootstrap::client"
include_recipe "rabbitmq"
include_recipe "nanite::chef"
include_recipe "java"

case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f >= 8.10
    include_recipe "couchdb"
  end
when "debian"
  if node[:platform_version].to_f >= 5.0 || node[:platform_version] =~ /.*sid/
    include_recipe "couchdb"
  end
when "centos","redhat","fedora"
  include_recipe "couchdb"
else
  Chef::Log.info("Unknown platform for CouchDB. Manual installation of CouchDB required.")
end

if CHEF_08_GEMS_RELEASED
  %w{ chef-server chef-server-slice chef-solr }.each do |gem|
    gem_package gem do
      version node[:bootstrap][:chef][:server_version]
    end
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

bash "Create WebUI SSL Certificate" do
  cwd "/etc/chef"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > webui.key
  openssl req -subj "#{node[:chef][:server_ssl_req]}" -new -x509 -nodes -sha1 -days 3650 -key webui.key > webui.crt
  cat webui.key webui.crt > webui.pem
  EOH
  not_if { File.exists?("/etc/chef/webui.pem") }
end

bash "Create Validation SSL Certificate" do
  cwd "/etc/chef"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > validation.key
  openssl req -subj "#{node[:chef][:server_ssl_req]}" -new -x509 -nodes -sha1 -days 3650 -key validation.key > validation.crt
  cat validation.key validation.crt > validation.pem
  EOH
  not_if { File.exists?("/etc/chef/validation.pem") }
end

%w{ openid cache search_index openid/cstore openid/store }.each do |dir|
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

  Chef::Log.info("You specified service style 'init'.")
  Chef::Log.info("'init' scripts available in #{node[:languages][:ruby][:gems_dir]}/gems/chef-#{node[:bootstrap][:chef][:client_version]}/distro")
when "bsd"
  Chef::Log.info("You specified service style 'bsd'. You will need to set up your rc.local file for chef-indexer and chef-server.")
  Chef::Log.info("Server startup command: chef-server -c2 -d")
else
  Chef::Log.info("Could not determine service init style, manual intervention required to set up indexer and server services.")
end
