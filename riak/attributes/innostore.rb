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

if node[:riak][:kv][:storage_backend].eql?("innostore_riak")
  set_unless[:riak][:kv][:storage_backend_options][:log_buffer_size] = 8388608
  set_unless[:riak][:kv][:storage_backend_options][:log_files_in_group] = 8
  set_unless[:riak][:kv][:storage_backend_options][:log_file_size] = 268435456
  set_unless[:riak][:kv][:storage_backend_options][:flush_log_at_trx_commit] = 1
  set_unless[:riak][:kv][:storage_backend_options][:data_home_dir] = "/var/lib/riak/innodb"
  set_unless[:riak][:kv][:storage_backend_options][:log_group_home_dir] = "/var/lib/riak/innodb"
  set_unless[:riak][:kv][:storage_backend_options][:buffer_pool_size] = 2147483648
end