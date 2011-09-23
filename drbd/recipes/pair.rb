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

include_recipe "drbd"

#if remote host is blank, search for partner
if node['drbd']['remote_host'].nil?
  remotes = search(:node, 'drbd:*') || []
  remotes.each do |remote|
    Chef::Log.info "drbd::pair remotes #{remote.name}"
    unless remote.name.equal?(node.name)
      Chef::Log.info "drbd::pair found #{remote.name}"
      node['drbd']['remote_host'] = remote.name
      node['drbd']['remote_ip'] = remote.ipaddress
    end
  end
end

template "/etc/drbd.d/pair.res" do
  source "res.erb"
  variables( :mount => "pair" )
  owner "root"
  group "root"
  not_if { node['drbd']['remote_host'].nil? }
  #notifies :restart, resources(:service => "drbd"), :immediate
end

#first pass only, initialize drbd
#drbdadm create-md resource

#drbdadm up resource

#cat /proc/drbd to see state
#drbd-overview

#select the initial sync source, key off of node['drbd']['master']
#if not master, wait for search to return a master

#if you are the master
#drbdadm primary --force resource

#You may now create a filesystem on the device, use it as a raw block device, mount it, and perform any other operation you would with an accessible block device.
#package xfsprogs
#mkfs -t node['drbd']['fs_type'] node['drbd']['dev']

# mount node['drbd']['mount'] do
#   device node['drbd']['dev']
#   fstype node['drbd']['fs_type']
#   options "rw"
# end
