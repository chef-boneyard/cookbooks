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

set_unless[:riak][:package][:type] = "binary"
set_unless[:riak][:package][:version][:major] = "0"
set_unless[:riak][:package][:version][:minor] = "11"
set_unless[:riak][:package][:version][:incremental] = "0"
set_unless[:riak][:package][:version][:build] = "1344"
set_unless[:riak][:package][:source_checksum] = "5c4222f1617032905473ce2ef4740890df0df5941e8c7f9c3e0b59e563938e98"
if node[:riak][:package][:type].eql?("source")
  set_unless[:riak][:package][:prefix] = "/usr/local"
  set_unless[:riak][:package][:config_dir] = node[:riak][:package][:prefix] + "/riak/etc"
end
set_unless[:riak][:package][:config_dir] = "/etc/riak"
