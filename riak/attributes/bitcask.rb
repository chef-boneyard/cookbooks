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

if node[:riak][:kv][:storage_backend].eql?("riak_kv_bitcask_backend")
  # set_unless[:riak][:kv][:storage_backend_options][:sync_interval] = 60
  # set_unless[:riak][:kv][:storage_backend_options][:merge_interval] = 60
  set_unless[:riak][:kv][:storage_backend_options][:writes_per_fsync] = 1
  set_unless[:riak][:kv][:storage_backend_options][:data_root] = "/var/lib/riak/bitcask"  
end