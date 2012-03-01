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
  elsif platform_version =~ /squeeze/
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:data_dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  set[:postgresql][:conf_dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"

when "ubuntu"

  case
  when platform_version.to_f <= 9.04
    default[:postgresql][:version] = "8.3"
  when platform_version.to_f <= 11.04
    default[:postgresql][:version] = "8.4"
  else
    default[:postgresql][:version] = "9.1"
  end

  set[:postgresql][:data_dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  set[:postgresql][:conf_dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"

when "fedora"

  if platform_version.to_f <= 12
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:data_dir] = "/var/lib/pgsql/data"
  set[:postgresql][:conf_dir] = "/var/lib/pgsql/data"

when "redhat","centos","scientific","amazon"

  default[:postgresql][:version] = "8.4"
  set[:postgresql][:data_dir] = "/var/lib/pgsql/data"
  set[:postgresql][:conf_dir] = "/var/lib/pgsql/data"

when "suse"

  if platform_version.to_f <= 11.1
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end

  set[:postgresql][:data_dir] = "/var/lib/pgsql/data"
  set[:postgresql][:conf_dir] = "/var/lib/pgsql/data"

else
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:data_dir]         = "/var/lib/postgresql/#{node[:postgresql][:version]}/main"
  set[:postgresql][:conf_dir]         = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  
end

# Defaults for tunable settings

# file locations
default[:postgresql][:hba_file]          = "#{node[:postgresql][:conf_dir]}/pg_hba.conf"
default[:postgresql][:ident_file]        = "#{node[:postgresql][:conf_dir]}/pg_ident.conf"
default[:postgresql][:external_pid_file]    = "/var/run/postgresql/#{node[:postgresql][:version]}-main.pid"
# connections
default[:postgresql][:listen_addresses]     = "localhost"
default[:postgresql][:port]                 = 5432
default[:postgresql][:max_connections]      = 100
default[:postgresql][:unix_socket_directory]      = "/var/run/postgresql"
# security and authentication
case node[:postgresql][:version]
when "8.3"
  default[:postgresql][:ssl] = "off"
when "8.4"
  default[:postgresql][:ssl] = "true"
when "9.1"
  default[:postgresql][:ssl] = "true"
end
default[:postgresql][:ssl_renegotiation_limit]  = "512MB"
# resource tuning
default[:postgresql][:shared_buffers] = "24MB"
default[:postgresql][:work_mem] = "1MB"
default[:postgresql][:maintenance_work_mem] = "16MB"
# archiving
default[:postgresql][:wal_level] = 'minimal'
default[:postgresql][:archive_mode] = "off"
default[:postgresql][:archive_command] = ""
# replication
default[:postgresql][:max_wal_senders] = 0
default[:postgresql][:wall_keep_segments] = 0
# standby
default[:postgresql][:hot_standby] = "off"
# logs
default[:postgresql][:log_min_duration_statement] = "-1"