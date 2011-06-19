#/postgresql.conf.
# Cookbook Name:: postgresql
# Recipe:: server
#
# Copyright 2009-2010, Opscode, Inc.
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

include_recipe "postgresql::client"

# Create a group and user like the package will.
# Otherwise the templates fail.

group "postgres" do
  # Workaround lack of option for -r and -o...
  group_name "-r -o postgres"
  not_if { Etc.getgrnam("postgres") }
  gid 26
end

user "postgres" do
  # Workaround lack of option for -M and -n...
  username "-M -n postgres"
  not_if { Etc.getpwnam("postgres") }
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home "/var/lib/pgsql"
  gid "postgres"
  system true
  uid 26
  supports :non_unique => true
end

package "postgresql" do
  case node.platform
  when "redhat","centos"
    package_name "postgresql#{node.postgresql.version.split('.').join}"
  else
    package_name "postgresql"
  end
end

case node.platform
when "redhat","centos"
  package "postgresql#{node.postgresql.version.split('.').join}-server"
when "fedora","suse"
  package "postgresql-server"
end

execute "/sbin/service postgresql initdb" do
  not_if { ::FileTest.exist?(File.join(node.postgresql.dir, "PG_VERSION")) }
end

service "postgresql" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "redhat.pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "redhat.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end
