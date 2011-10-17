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

Chef::Log.warn("The chef::client recipe is deprecated. It is replaced by the chef-client::config recipe.")
Chef::Log.warn("Including the chef-client::config recipe now.")

node.set['chef_client']['init_style'] = node['chef']['init_style']
node.set['chef_client']['path'] = node['chef']['path']
node.set['chef_client']['run_path'] = node['chef']['run_path']
node.set['chef_client']['cache_path'] = node['chef']['cache_path']
node.set['chef_client']['backup_path'] = node['chef']['backup_path']
node.set['chef_client']['umask'] = node['chef']['umask']
node.set['chef_client']['server_url'] = node['chef']['server_url']
node.set['chef_client']['log_dir'] = node['chef']['log_dir']
node.set['chef_client']['validation_client_name'] = node['chef']['validation_client_name']
node.set['chef_client']['interval'] = node['chef']['interval']
node.set['chef_client']['splay'] = node['chef']['splay']

include_recipe "chef-client::config"
