#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: client
#
# Copyright 2009-2012, Opscode, Inc.
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

if Chef::Config[:solo]
  Chef::Log.info("#{cookbook_name}::#{recipe_name} is intended for use with Chef Server, use #{cookbook_name}::default with Chef Solo.")
  return
end

query = "role:#{node['postfix']['relayhost_role']}"
relayhost = ""
results = []

if node.run_list.roles.include?(node['postfix']['relayhost_role'])
  relayhost << node['ipaddress']
elsif node['postfix']['multi_environment_relay']
  results = search(:node, query)
  relayhost = results.map {|n| n['ipaddress']}.first
else
  results = search(:node, "#{query} AND chef_environment:#{node.chef_environment}")
  relayhost = results.map {|n| n['ipaddress']}.first
end

node.set['postfix']['relayhost'] = "[#{relayhost}]"

include_recipe "postfix"
