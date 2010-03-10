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

# STRUCTURE OF THE CASSANDRA DATA BAG
# 
# {:cassandra =>
#   {:clusters =>
#     {<cluster name> =>
#       {:keyspaces =>
#         [{:name => <keyspace name>,
#           :columns => [{<attrib> => <value>}, ...],
#           :replica_placement_strategy => <strategy>,
#           :replication_factor => <factor>,
#           :end_point_snitch => <snitch>
#         }],
#        :seeds =>
#          [<seed addr>, ...],
#        <other per cluster settings>
#       }
#     }
#   }
# }
#
# COLUMN ATTRIBS
#
# Simple columns: {:name => <column name>, :compare_with => <comparison>}
# Super columns: {:name => <column name>, :compare_with => <comparison>,
#                 :column_type => "Super", :compare_subcolumns_with => <comparison>}
#

# Load cluster settings from chef-server
cassandra_info = data_bag('cassandra')
node[:cassandra].merge!(cassandra_info[:clusters][node[:cassandra][:cluster_name]])

# Configure the various addrs for binding
node[:cassandra][:listen_addr] = node[:ipaddress]
node[:cassandra][:thrift_addr] = node[:ipaddress]

include_recipe "cassandra::default"
