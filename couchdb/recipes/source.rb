#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: couchdb
# Recipe:: source
#
# Copyright 2010, Opscode, Inc
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

include_recipe "erlang"

couchdb_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "apache-couchdb-#{node[:couch_db][:src_version]}.tar.gz")

case node[:platform]
when "debian", "ubuntu"
  %w{ libmozjs-dev libicu-dev libcurl4-openssl-dev }.each do |pkg|
    package pkg
  end
end

remote_file couchdb_tar_gz do
  checksum node[:couch_db][:src_checksum]
  source node[:couch_db][:src_mirror]
end

bash "install couchdb #{node[:couch_db][:src_version]}" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{couchdb_tar_gz}
    cd apache-couchdb-#{node[:couch_db][:src_version]} && ./configure && make && make install
  EOH
  not_if { ::FileTest.exists?("/usr/local/bin/couchdb") }
end

user "couchdb" do
  home "/usr/local/var/lib/couchdb"
  comment "CouchDB Administrator"
  supports :manage_home => false
end

%w{ var/lib/couchdb var/log/couchdb var/run etc/couchdb }.each do |dir|
  directory "/usr/local/#{dir}" do
    owner "couchdb"
    group "couchdb"
    mode "0770"
  end
end

remote_file "/etc/init.d/couchdb" do
  source "couchdb.init"
  owner "root"
  group "root"
  mode "0755"
end

service "couchdb" do
  supports [ :restart, :status ]
  action [:enable, :start]
end
