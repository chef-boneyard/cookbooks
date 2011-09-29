#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: drbd
# Recipe:: pair
#
# Copyright 2011, Opscode, Inc
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

require 'chef/shell_out'

include_recipe "drbd"

#if remote host is blank, search for partner
if node['drbd']['remote_host'].nil?
  remotes = search(:node, 'drbd:*') || []
  masters = 0
  remotes.each do |remote|
    masters += 1 if remote['drbd']['master']
    unless node.name.eql?(remote.name)
      Chef::Log.info "drbd::pair found #{remote.name}"
      node['drbd']['remote_host'] = remote.name
      node['drbd']['remote_ip'] = remote.ipaddress
    end
  end
  if (masters > 1)
    Chef::Application.fatal! "You may not have more than 1 master nodes for drbd."
  end
end

template "/etc/drbd.d/pair.res" do
  source "res.erb"
  variables( :mount => "pair" )
  owner "root"
  group "root"
  not_if { node['drbd']['remote_host'].nil? }
  action :create
end

first_pass = false

#first pass only, initialize drbd
execute "drbdadm create-md pair" do
  subscribes :run, resources(:template => "/etc/drbd.d/pair.res")
  notifies :restart, resources(:service => "drbd"), :immediate
  only_if do
    cmd = Chef::ShellOut.new("drbd-overview")
    overview = cmd.run_command
    Chef::Log.info overview.stdout
    overview.stdout.include?("drbd not loaded")
    first_pass = true
  end
  not_if { node['drbd']['remote_host'].nil? }
  action :nothing
end

#claim primary based off of node['drbd']['master']
execute "drbdadm -- --overwrite-data-of-peer primary all" do
  subscribes :run, resources(:execute => "drbdadm create-md pair")
  only_if { node['drbd']['master'] && !node['drbd']['remote_host'].nil? }
  action :nothing
end

#You may now create a filesystem on the device, use it as a raw block device
execute "mkfs -t #{node['drbd']['fs_type']} #{node['drbd']['dev']}" do
  subscribes :run, resources(:execute => "drbdadm -- --overwrite-data-of-peer primary all")
  only_if { node['drbd']['master'] && !node['drbd']['remote_host'].nil? }
  action :nothing
end

directory node['drbd']['mount'] do
  only_if { node['drbd']['master'] && !node['drbd']['remote_host'].nil? }
  action :create
end

#mount -t xfs -o rw /dev/drbd0 /shared
mount node['drbd']['mount'] do
  device node['drbd']['dev']
  fstype node['drbd']['fs_type']
  only_if { node['drbd']['master'] && !node['drbd']['remote_host'].nil? && !first_pass}
  action :mount
end
