#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: sql_server
# Recipe:: server
#
# Copyright:: 2011, Opscode, Inc.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

service_name = "MSSQL$#{node['sql_server']['instance_name']}"

# generate and set a password for the 'sa' super user
node.set_unless['sql_server']['server_sa_password'] = secure_password
node.save # force a save so we don't lose our generated password on a failed chef run

config_file_path = File.join(Chef::Config[:file_cache_path], "ConfigurationFile.ini")

template config_file_path do
  source "ConfigurationFile.ini.erb"
end

windows_package node['sql_server']['server']['package_name'] do
  source node['sql_server']['server']['url']
  checksum node['sql_server']['server']['checksum']
  installer_type :custom
  options "/q /ConfigurationFile=#{Windows::Helper.win_friendly_path(config_file_path)}"
  action :install
end

# Workaround for CHEF-2541
# The restart action for the Windows
# service provider doesn't like long stops
# Quick fix is to create a restart bat file
# and manually set the restart_command on the 
# service resource
gem_package "win32-service" do
  options '--platform=mswin32'
  action :install
end

restart_path = File.join(node['sql_server']['install_dir'], 'restart.rb')

template restart_path do
  source "restart.rb.erb"
  variables :service_name => service_name
end

service service_name do
  restart_command "ruby '#{restart_path}'"
  action :nothing
end

# set the static tcp port
windows_registry "set-static-tcp-port"  do
  key_name 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.' << node['sql_server']['instance_name'] << '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'
  values 'TcpPort' => node['sql_server']['port'].to_s, 'TcpDynamicPorts' => ""
  action :force_modify
  notifies :restart, "service[#{service_name}]", :immediately
end

include_recipe 'sql_server::client'