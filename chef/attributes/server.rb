#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Attributes:: server
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

# change to languages[:ruby][:gems_dir] when ohai is updated
gems_path %x{gem env gemdir}.chomp!

chef Mash.new unless attribute?("chef")
chef[:server_version] = "0.6.0"  unless chef.has_key?(:server_version)
chef[:server_log] = "/var/log/chef/server.log" unless chef.has_key?(:server_log)
chef[:server_path] = "#{gems_path}/gems/chef-server-#{chef[:server_version]}"
chef[:server_hostname] = fqdn unless chef.has_key?(:server_hostname)
chef[:server_fqdn] = "#{chef[:server_hostname]}.#{domain}" unless chef.has_key?(:server_fqdn)
