#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2008-2009, Opscode, Inc.
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

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:mysql][:server_debian_password] = secure_password
set_unless[:mysql][:server_root_password] = secure_password
set_unless[:mysql][:server_repl_password] = secure_password
set_unless[:mysql][:bind_address]         = ipaddress
set_unless[:mysql][:datadir]              = "/var/lib/mysql"

if attribute?(:ec2)
  set_unless[:mysql][:ec2_path]    = "/mnt/mysql"
  set_unless[:mysql][:ebs_vol_dev] = "/dev/sdi"
  set_unless[:mysql][:ebs_vol_size] = 50
end

# Tunables
set_unless[:mysql][:tunable][:key_buffer]          = "250M"
set_unless[:mysql][:tunable][:max_connections]     = "800"
set_unless[:mysql][:tunable][:wait_timeout]        = "180"
set_unless[:mysql][:tunable][:net_read_timeout]    = "30"
set_unless[:mysql][:tunable][:net_write_timeout]   = "30"
set_unless[:mysql][:tunable][:back_log]            = "128"
set_unless[:mysql][:tunable][:table_cache]         = "128"
set_unless[:mysql][:tunable][:max_heap_table_size] = "32M"
