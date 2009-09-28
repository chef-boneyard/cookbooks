# Cookbook Name:: redmine
# Attributes:: redmine
#
# Copyright 2009, Opscode, Inc
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

db_password = ""
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| db_password << chars[rand(chars.size-1)] }

#database_server = search(:node, "database_master:true").map {|n| n['fqdn']}.first

redmine Mash.new unless attribute?("redmine")
redmine[:dl_id]   = "56909" unless redmine.has_key?(:dl_id)
redmine[:version] = "0.8.4" unless redmine.has_key?(:version)
redmine[:dir]     = "/srv/redmine-#{redmine[:version]}"

redmine[:db] = Mash.new unless redmine.has_key?(:db)
redmine[:db][:type]     = "sqlite"        unless redmine[:db].has_key?(:type)
redmine[:db][:user]     = "redmine"       unless redmine[:db].has_key?(:user)
redmine[:db][:password] = db_password     unless redmine[:db].has_key?(:password)
redmine[:db][:hostname] = "localhost"     unless redmine[:db].has_key?(:hostname)
