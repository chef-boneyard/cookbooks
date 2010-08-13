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

default.riak.package[:type] = "binary"
default.riak.package.version.major = "0"
default.riak.package.version.minor = "12"
default.riak.package.version.incremental = "0"
default.riak.package.version.build = "1"
default.riak.package.source_checksum = "cad9ccf56fae3adfacefb397c8c37fd95bb0367eb74d372c5120266ff98f71c8"
if (node[:riak][:package][:type]).eql?("source")
  default.riak.package.prefix = "/usr/local"
  default.riak.package.config_dir = node.riak.package.prefix + "/riak/etc"
end
default.riak.package.config_dir = "/etc/riak"
