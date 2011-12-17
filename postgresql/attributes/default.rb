#
# Cookbook Name:: postgresql
# Attributes:: postgresql
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

case platform
when "debian"
  if platform_version.to_f == 5.0
    default[:postgresql][:version] = "8.3"
	elsif platform_version.to_f == 6.0
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"

when "ubuntu"

  case
  when platform_version.to_f <= 9.04
    default[:postgresql][:version] = "8.3"
  when platform_version.to_f <= 11.04
    default[:postgresql][:version] = "8.4"
  else
    default[:postgresql][:version] = "9.1"
  end

  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"

when "fedora"

  if platform_version.to_f <= 12
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:dir] = "/var/lib/pgsql/data"

when "redhat","centos","scientific","amazon"

  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir] = "/var/lib/pgsql/data"

when "suse"

  if platform_version.to_f <= 11.1
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:dir] = "/var/lib/pgsql/data"

else
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir]         = "/etc/postgresql/#{node[:postgresql][:version]}/main"
end

# basic configuration
default[:postgresql][:listen_address] = 'localhost'
default[:postgresql][:port] = 5432

# tunable
default[:postgresql][:tunable][:max_connections] = 100
default[:postgresql][:tunable][:shared_buffers] = '24MB'
default[:postgresql][:tunable][:effective_cache_size] = '128MB'
default[:postgresql][:tunable][:work_mem] = '1MB'

default[:postgresql][:tunable][:synchronous_commit] = 'on'
default[:postgresql][:tunable][:wal_buffer] = '64kB'
default[:postgresql][:tunable][:wal_sync_method] = 'fsync'

default[:postgresql][:tunable][:checkpoint_segments] = 3
default[:postgresql][:tunable][:checkpoint_timeout] = '5min'
default[:postgresql][:tunable][:checkpoint_completion_target] = 0.5


