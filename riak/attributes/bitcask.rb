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

if node.riak.kv.storage_backend == :riak_kv_bitcask_backend   
  default.riak.bitcask.data_root = "/var/lib/riak/bitcask"  
  default.riak.bitcask.max_file_size = 2147483648
  default.riak.bitcask.open_timeout = 4
  # Sync strategy is one of: :none, :o_sync, {:seconds => N}
  default.riak.bitcask.sync_strategy = :none
  unless (node.riak.bitcask).to_hash["sync_strategy"].is_a?(Mash)
    node.riak.bitcask.sync_strategy = (node.riak.bitcask.sync_strategy).to_s.to_sym
  end
  default.riak.bitcask.frag_merge_trigger = 60
  default.riak.bitcask.dead_bytes_merge_trigger = 536870912
  default.riak.bitcask.frag_threshold = 40
  default.riak.bitcask.dead_bytes_threshold = 134217728
  default.riak.bitcask.small_file_threshold = 10485760
  default.riak.bitcask.expiry_secs = -1
end
