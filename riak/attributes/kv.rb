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

set_unless[:riak][:kv][:raw_name] = "riak"
set_unless[:riak][:kv][:storage_backend] = "riak_kv_dets_backend"
set_unless[:riak][:kv][:storage_backend_options] = Mash.new
case node[:riak][:kv][:storage_backend]
when "riak_kv_dets_backend"
  set_unless[:riak][:kv][:storage_backend_options][:riak_kv_dets_backend_root] = "data/dets"
when "innostore"
  include_attribute "riak::innostore"
end
set_unless[:riak][:kv][:riak_stat_enabled] = "false"
set_unless[:riak][:kv][:handoff_port] = "8099"
set_unless[:riak][:kv][:js_vm_count] = 8
