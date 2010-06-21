#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef
# Attributes:: default
#
# Copyright 2008-2010, Opscode, Inc
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

set_unless[:chef][:umask]      = "0022"
set_unless[:chef][:url_type]   = "http"
set_unless[:chef][:init_style] = "runit"

case platform
when "openbsd","freebsd"
  set_unless[:chef][:path]       = "/var/chef"
  set_unless[:chef][:run_path]   = "/var/run"
  set_unless[:chef][:cache_path] = "/var/chef/cache"
  set_unless[:chef][:serve_path] = "/var/chef"
else
  set_unless[:chef][:path]       = "/srv/chef"
  set_unless[:chef][:serve_path] = "/srv/chef"
  set_unless[:chef][:run_path]   = "#{chef[:path]}/run"
  set_unless[:chef][:cache_path] = "#{chef[:path]}/cache"
  set_unless[:chef][:backup_path] = "#{chef[:path]}/backup"
end

set_unless[:chef][:server_version]  = node.chef_packages.chef[:version]
set_unless[:chef][:client_version]  = node.chef_packages.chef[:version]
set_unless[:chef][:client_interval] = "1800"
set_unless[:chef][:client_splay]    = "20"
set_unless[:chef][:log_dir]         = "/var/log/chef"
set_unless[:chef][:server_port]     = "4000"
set_unless[:chef][:webui_port]      = "4040"
set_unless[:chef][:webui_enabled]   = false
set_unless[:chef][:solr_heap_size]  = "256M"
set_unless[:chef][:validation_client_name] = "chef-validator"

set_unless[:chef][:server_fqdn]     = node.has_key?(:domain) ? "chef.#{domain}" : "chef"
set_unless[:chef][:server_url]      = "#{node.chef.url_type}://#{node.chef.server_fqdn}:#{node.chef.server_port}"
