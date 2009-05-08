#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Attributes:: client
#
# Copyright 2008-2009, Opscode, Inc
# Copyright 2009, 37signals
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

chef Mash.new unless attribute?("chef")
# chef[:client_path] = `which chef-client`.chomp
chef[:client_version] = "0.6.2" unless chef.has_key?(:client_version)
chef[:client_interval] = "1800" unless chef.has_key?(:client_interval)
chef[:client_splay] = "20"      unless chef.has_key?(:client_splay)
chef[:client_log] = "/var/log/chef/client.log" unless chef.has_key?(:client_log)
