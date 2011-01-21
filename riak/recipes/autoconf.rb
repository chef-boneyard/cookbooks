#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
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

include_recipe "riak::default"

if node[:riak][:package][:type] == "binary"
  bin_path = "/usr/sbin"
else
  bin_path = "#{node[:riak][:package][:prefix]}/riak/bin"
end

# Riak's packaged init.d script doesn't work. We'll use the bin script
# instead.
bash "Start riak and wait for riak_kv to be available" do
  code <<-SCRIPT
#{bin_path}/riak start
#{bin_path}/riak-admin wait-for-service riak_kv #{node[:riak][:erlang][:node_name]}
SCRIPT
  timeout 45
end

riak_cluster node[:riak][:core][:cluster_name] do
  node_name node[:riak][:erlang][:node_name]
  action :join
  riak_admin_path bin_path
end
