#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
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


default.riak.kv.mapred_queue_dir = "/var/lib/riak/mr_queue"
default.riak.kv.mapper_batch_size = 5
default.riak.kv.map_js_vm_count = 8
default.riak.kv.reduce_js_vm_count = 6
default.riak.kv.hook_js_vm_count = 2
default.riak.kv.js_max_vm_mem = 8
default.riak.kv.js_thread_stack = 16
default.riak.kv.mapred_name = "mapred"
default.riak.kv.raw_name = "riak"
default.riak.kv.riak_kv_stat = true
default.riak.kv.stats_urlpath = "stats"
default.riak.kv.pb_ip = "0.0.0.0"
default.riak.kv.pb_port = 8087
default.riak.kv.storage_backend = :riak_kv_bitcask_backend
node.riak.kv.storage_backend = (node.riak.kv.storage_backend).to_s.to_sym
