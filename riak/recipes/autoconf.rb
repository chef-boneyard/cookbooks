#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: riak
# Recipe:: autoconf
#
# Copyright (c) 2010 Basho Technologies, Inc.
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

require 'socket'

seeds = intra = []
search(:node, "riak_node_cluster_name:#{node[:riak][:node][:cluster_name]}") do |n|
  intra << IPSocket.getaddress(n["riak"]["erlang"]["node_name"].split("@").last)
  if n["riak"]["node"]["seed"]
    seeds << n["ipaddress"] unless n["ipaddress"].eql?(node[:ipaddress])
  end
end
node[:riak][:core][:default_gossip_seed] = seeds.sort_by{rand}.first if seeds.length > 0

include_recipe "riak::default"
