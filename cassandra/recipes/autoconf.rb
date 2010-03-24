#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: cassandra
# Recipe:: autoconf
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

# STRUCTURE OF THE CASSANDRA DATA BAG (meaning a databag named 'cassandra')
# 
#   {:id : "clusters",
#     {<cluster name> =>
#       {:keyspaces =>
#         {<keyspace name> => {
#           :columns => {<column name> => {<attrib> => <value>, ...}, ...},
#           :replica_placement_strategy => <strategy>,
#           :replication_factor => <factor>,
#           :end_point_snitch => <snitch>
#         }},
#        <other per cluster settings>
#       }
#     }
#   }
#
# COLUMN ATTRIBS
#
# Simple columns: {:compare_with => <comparison>}
# Super columns: {:compare_with => <comparison>, :column_type => "Super", :compare_subcolumns_with => <comparison>}
#
# Columns may optionally include:
#   :rows_cached => <count>|<percent>% (:rows_cached => "1000", or :rows_cached => "50%")
#   :keys_cached => <count>|<percent>% (:keys_cached => "1000", or :keys_cached => "50%")
#   :comment => <comment string>

# Gather the seeds
#
# Nodes are expected to be tagged with [:cassandra][:cluster_name] to indicate the cluster to which
# they belong (nodes are in exactly 1 cluster in this version of the cookbook), and may optionally be
# tagged with [:cassandra][:seed] set to true if a node is to act as a seed.
clusters = data_bag_item('cassandra', 'clusters')
clusters[node[:cassandra][:cluster_name]].each_pair do |k, v|
  node[:cassandra][k] = v
end
node.save

local_addr = "" ; seeds = []
if node[:rackspace]
  local_addr = node[:rackspace][:private_ip]
  seeds = (search(:node, "cassandra_cluster_name:#{node[:cassandra][:cluster_name]} AND cassandra_seed:true").map do |n|
    n["rackspace"]["private_ip"] if n["rackspace"]
  end).compact # This compaction is done to work around OHAI-170.
               # Once the OHAI-170 fix is merged in ohai, the compaction should be removed.
  seeds = ["127.0.0.1"] unless seeds.length > 0
else
  local_addr = node[:ipaddress]
  seeds = search(:node, "cassandra_cluster_name:#{node[:cassandra][:cluster_name]} AND cassandra_seed:true").map {|n| n["ipaddress"]}
  seeds = ["127.0.0.1"] unless seeds.length > 0
end

node[:cassandra][:seeds] = seeds

# Configure the various addrs for binding
node[:cassandra][:listen_addr] = local_addr
node[:cassandra][:thrift_addr] = local_addr

include_recipe "cassandra::default"
