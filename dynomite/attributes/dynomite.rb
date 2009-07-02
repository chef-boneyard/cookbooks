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

dynomite Mash.new unless attribute?("dynomite")

dynomite[:master]       = false              unless dynomite.has_key?(:master)
dynomite[:cluster_name] = "dynomite"         unless dynomite.has_key?(:cluster_name)
dynomite[:data_dir]     = "/var/db/dynomite" unless dynomite.has_key?(:data_dir)
dynomite[:num_nodes]    = 1                  unless dynomite.has_key?(:num_nodes)
dynomite[:node_name]    = hostname           unless dynomite.has_key?(:node_name)
dynomite[:ascii_port]   = 11221              unless dynomite.has_key?(:ascii_port)
dynomite[:thrift_port]  = 11222              unless dynomite.has_key?(:thrift_port)
dynomite[:web_port]     = 1180               unless dynomite.has_key?(:web_port)

master_node = search(:node, "dynomite_master:true", "fqdn").first

dynomite[:join_node]    = master_node        unless dynomite.has_key?(:join_node)
