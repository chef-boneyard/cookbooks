#
# Cookbook Name:: ossec
# Recipe:: server
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

node.set['ossec']['user']['install_type'] = "server"
node.set['ossec']['server']['maxagents']  = 1024

node.save

include_recipe "ossec"

agent_manager = "#{node['ossec']['user']['dir']}/bin/ossec-batch-manager.pl"

ssh_hosts = Array.new

search(:node, "ossec:[* TO *] NOT role:#{node['ossec']['server_role']}") do |n|

  ssh_hosts << n['ipaddress'] if n['keys']

  execute "#{agent_manager} -a --ip #{n['ipaddress']} -n #{n['hostname']}" do
    not_if "grep '#{n['hostname']} #{n['ipaddress']}' #{node['ossec']['user']['dir']}/etc/client.keys"
  end

end

template "/usr/local/bin/dist-ossec-keys.sh" do
  source "dist-ossec-keys.sh.erb"
  owner "root"
  group "root"
  mode 0755
  variables(:ssh_hosts => ssh_hosts)
  not_if { ssh_hosts.empty? }
end

ossec_key = data_bag_item("ossec", "ssh")

directory "#{node['ossec']['user']['dir']}/.ssh" do
  owner "root"
  group "ossec"
  mode 0750
end

template "#{node['ossec']['user']['dir']}/.ssh/id_rsa" do
  source "ssh_key.erb"
  owner "root"
  group "ossec"
  mode 0600
  variables(:key => ossec_key['privkey'])
end

cron "distribute-ossec-keys" do
  minute "0"
  command "/usr/local/bin/dist-ossec-keys.sh"
  only_if { ::File.exists?("#{node['ossec']['user']['dir']}/etc/client.keys") }
end
