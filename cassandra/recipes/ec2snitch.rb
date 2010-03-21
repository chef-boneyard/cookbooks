#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: cassandra
# Recipe:: ec2snitch
#
# Copyright 2010, Benjamin Black
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

# To use this, you MUST install contrib/property_snitch and set the keyspace[:e
# to org.apache.cassandra.locator.PropertyFileEndPointSnitch.  See contrib/prop
# in the cassandra distribution for details.

@topo_map = search(:node, "cassandra_cluster_name:#{node[:cassandra][:cluster_name]} AND ec2:placement_availability_zone").map do |n|
  az_parts = n[:ec2][:placement_availability_zone].split('-')
  @topo_map[n['ipaddress']] = {:port => n[:cassandra][:storage_port],
                               :rack => az_parts.last[1],
                               :dc => az_parts[0..1].join('-') + "-#{az_parts.last[0]}"}
end

node.set_unless[:cassandra][:ec2_snitch_default_az] = "us-east-1a"
default_az_parts = node[:cassandra][:ec2_snitch_default_az].split('-')
@default_az = {:rack => default_az_parts.last[1], :dc => default_az_parts[0..1].join('-') + "-#{default_az_parts.last[0]}"}

template "/etc/cassandra/rack.properties" do
  variables(:topo_map => @topo_map, :default_az => @default_az)
  source "rack.properties.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "cassandra")
end