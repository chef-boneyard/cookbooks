#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2008, Opscode, Inc.
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
db_password = ""
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| db_password << chars[rand(chars.size-1)] }

mysql Mash.new unless attribute?("mysql")
mysql[:server_root_password] = db_password unless mysql.has_key?(:server_root_password)
mysql[:bind_address]         = ipaddress unless mysql.has_key?(:bind_address)
mysql[:datadir]              = "/var/lib/mysql" unless mysql.has_key?(:datadir)
mysql[:ec2_path] = "/mnt/mysql" unless mysql.has_key?(:ec2_path)

# Tunables
mysql[:tunable] = Mash.new unless mysql.has_key?(:tunable)
mysql[:tunable][:key_buffer]          = "250M" unless mysql[:tunable].has_key?(:key_buffer)
mysql[:tunable][:max_connections]     = "800" unless mysql[:tunable].has_key?(:max_connections)
mysql[:tunable][:wait_timeout]        = "180" unless mysql[:tunable].has_key?(:wait_timeout)
mysql[:tunable][:net_read_timeout]    = "30" unless mysql[:tunable].has_key?(:net_read_timeout)
mysql[:tunable][:net_write_timeout]   = "30" unless mysql[:tunable].has_key?(:net_write_timeout)
mysql[:tunable][:back_log]            = "128" unless mysql[:tunable].has_key?(:back_log)
mysql[:tunable][:table_cache]         = "128" unless mysql[:tunable].has_key?(:table_cache)
mysql[:tunable][:max_heap_table_size] = "32M" unless mysql[:tunable].has_key?(:max_heap_table_size)
