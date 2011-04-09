#
# Cookbook Name:: drizzle
# Attributes:: server
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

default[:drizzle][:bind_address]         = ipaddress
default[:drizzle][:datadir]              = "/var/lib/drizzle"

default[:drizzle][:tunable][:back_log]               = "128"
default[:drizzle][:tunable][:max_allowed_packet]     = "16M"
default[:drizzle][:tunable][:max_heap_table_size]    = "32M"
default[:drizzle][:tunable][:table_open_cache]       = "1024"
default[:drizzle][:tunable][:table_definition_cache] = "1024"
default[:drizzle][:tunable][:thread_stack]           = "10485760"
default[:drizzle][:tunable][:innodb_buffer_pool_size] = "256M"
