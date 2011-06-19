#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
#
# Cookbook Name:: chef
# Recipe:: bootstrap_server
#
# Copyright 2009-2010, Opscode, Inc.
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

Chef::Log.warn("This recipe is deprecated. It has been replaced by chef-server::rubygems-install.")
Chef::Log.warn("Including the chef-server::rubygems-install recipe now.")

node.set['chef_server']['init_style'] = node['chef']['init_style']
node.set['chef_server']['path'] = node['chef']['path']
node.set['chef_server']['run_path'] = node['chef']['run_path']
node.set['chef_server']['cache_path'] = node['chef']['cache_path']
node.set['chef_server']['backup_path'] = node['chef']['backup_path']
node.set['chef_server']['umask'] = node['chef']['umask']
node.set['chef_server']['url'] = node['chef']['server_url']
node.set['chef_server']['log_dir'] = node['chef']['log_dir']
node.set['chef_server']['api_port'] = node['chef']['server_port']
node.set['chef_server']['webui_port'] = node['chef']['webui_port']
node.set['chef_server']['webui_enabled'] = node['chef']['webui_enabled']
node.set['chef_server']['solr_heap_size'] = node['chef']['solr_heap_size']
node.set['chef_server']['validation_client_name'] = node['chef']['validation_client_name']

include_recipe "chef-server::rubygems-install"
