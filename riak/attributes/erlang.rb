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

include_attribute "riak::core"

set_unless[:riak][:erlang][:node_name] = "riak@#{node[:riak][:core][:web_ip]}"
set_unless[:riak][:erlang][:cookie] = "riak"
set_unless[:riak][:erlang][:kernel_polling] = true
set_unless[:riak][:erlang][:async_threads] = 5
set_unless[:riak][:erlang][:smp] = "enable"
set_unless[:riak][:erlang][:env_vars] = ["ERL_MAX_PORTS 4096", "ERL_FULLSWEEP_AFTER 10"]
