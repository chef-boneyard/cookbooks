#
# Cookbook Name:: ossec
# Recipe:: client
#
# Copyright 2010, Opscode, Inc.
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

ossec_server = Array.new

if node.run_list.roles.include?(node['ossec']['server_role'])
  ossec_server << node['ipaddress']
else
  search(:node,"role:#{node['ossec']['server_role']}") do |n|
    ossec_server << n['ipaddress']
  end
end

node.set['ossec']['user']['install_type'] = "agent"
node.set['ossec']['user']['agent_server_ip'] = ossec_server.first

node.save

include_recipe "ossec"

ossec_key = data_bag_item("ossec", "ssh")

user "ossecd" do
  comment "OSSEC Distributor"
  shell "/bin/bash"
  system true
  gid "ossec"
  home node['ossec']['user']['dir']
end

directory "#{node['ossec']['user']['dir']}/.ssh" do
  owner "ossecd"
  group "ossec"
  mode 0750
end

template "#{node['ossec']['user']['dir']}/.ssh/authorized_keys" do
  source "ssh_key.erb"
  owner "ossecd"
  group "ossec"
  mode 0600
  variables(:key => ossec_key['pubkey'])
end

file "#{node['ossec']['user']['dir']}/etc/client.keys" do
  owner "ossecd"
  group "ossec"
  mode 0660
end
