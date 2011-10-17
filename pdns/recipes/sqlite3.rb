#
# Cookbook Name:: pdns
# Recipe:: sqlite3
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "sqlite"

package "pdns-backend-sqlite3" do
  package_name value_for_platform(
    "arch" => { "default" => "pdns" },
    ["debian","ubuntu"] => { "default" => "pdns-backend-sqlite3" },
    ["redhat","centos","fedora"] => { "default" => "pdns-backend-sqlite3" },
    "default" => "pdns-backend-sqlite3"
  )
end

directory "/var/lib/pdns"

cookbook_file "/var/tmp/pdns_schema.sql" do
  source "schema.sql"
end

ruby_block "load pdns schema" do
  block do
    require 'sqlite3'
    SQLite3::Database.new("/var/lib/pdns/pdns.sqlite3") do |db|
      open("/var/tmp/pdns_schema.sql").each {|l| db.execute(l) }
    end
  end
end
