#
# Cookbook Name:: dynomite
# attributes:: dynomite
#
# Copyright 2009, Opscode, Inc.
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

default[:dynomite][:master]       = false
default[:dynomite][:cluster_name] = "dynomite"
default[:dynomite][:data_dir]     = "/var/db/dynomite"
default[:dynomite][:num_nodes]    = 1
default[:dynomite][:node_name]    = hostname
default[:dynomite][:ascii_port]   = 11221
default[:dynomite][:thrift_port]  = 11222
default[:dynomite][:web_port]     = 1180

master_node = search(:node, "dynomite_master:true", "fqdn").first

default[:dynomite][:join_node]    = master_node
