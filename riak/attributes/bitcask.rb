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

if node[:riak][:kv][:storage_backend] == :riak_kv_bitcask_backend   
  set_unless[:riak][:kv][:storage_backend_options][:data_root] = "/var/lib/riak/bitcask"  
  set_unless[:riak][:kv][:storage_backend_options][:max_file_size] = 2147483648
  set_unless[:riak][:kv][:storage_backend_options][:open_timeout] = 4
  # Sync strategy is one of: :none, :o_sync, {:seconds => N}
  set_unless[:riak][:kv][:storage_backend_options][:sync_strategy] = :none
  unless node[:riak][:kv][:storage_backend_options].to_hash["sync_strategy"].is_a?(Mash)
    node[:riak][:kv][:storage_backend_options][:sync_strategy] = node[:riak][:kv][:storage_backend_options][:sync_strategy].to_s.to_sym
  end
  set_unless[:riak][:kv][:storage_backend_options][:frag_merge_trigger] = 60
  set_unless[:riak][:kv][:storage_backend_options][:dead_bytes_merge_trigger] = 536870912
  set_unless[:riak][:kv][:storage_backend_options][:frag_threshold] = 40
  set_unless[:riak][:kv][:storage_backend_options][:dead_bytes_threshold] = 134217728
  set_unless[:riak][:kv][:storage_backend_options][:small_file_threshold] = 10485760
  set_unless[:riak][:kv][:storage_backend_options][:expiry_secs] = -1
end