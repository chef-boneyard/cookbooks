#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: riak
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

default.riak.kv.raw_name = "riak"
default.riak.kv.storage_backend = :riak_kv_bitcask_backend
node.riak.kv.storage_backend = (node.riak.kv.storage_backend).to_s.to_sym
default.riak.kv.riak_stat_enabled = true
default.riak.kv.pb_ip = "0.0.0.0"
default.riak.kv.pb_port = 8087
default.riak.kv.mapred_name = "mapred"
default.riak.kv.handoff_port = 8099
default.riak.kv.js_vm_count = 8
