#
# Cookbook Name:: bootstrap
# Attributes:: bootstrap
#
# Copyright 2008-2010, Opscode, Inc.
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

default[:bootstrap][:chef][:umask]      = 0022
default[:bootstrap][:chef][:url_type]   = "http"
default[:bootstrap][:chef][:init_style] = "runit"
default[:bootstrap][:chef][:path]       = "/srv/chef"
default[:bootstrap][:chef][:run_path]   = "/var/run/chef"
default[:bootstrap][:chef][:cache_path] = "#{bootstrap[:chef][:path]}/cache"
default[:bootstrap][:chef][:serve_path] = "/srv/chef"
default[:bootstrap][:chef][:server_port] = "4000"
default[:bootstrap][:chef][:webui_port]  = "4040"
default[:bootstrap][:chef][:webui_enabled] = false
default[:bootstrap][:chef][:webui_admin_password] = secure_password
default[:bootstrap][:chef][:validation_client_name] = "chef-validator"

default[:bootstrap][:chef][:server_version]  = node.chef_packages.chef[:version]
default[:bootstrap][:chef][:client_version]  = node.chef_packages.chef[:version]
default[:bootstrap][:chef][:client_interval] = "1800"
default[:bootstrap][:chef][:client_splay]    = "20"
default[:bootstrap][:chef][:log_dir]         = "/var/log/chef"

case bootstrap[:chef][:init_style]
when "runit"
  default[:bootstrap][:chef][:client_log]  = "STDOUT"
  default[:bootstrap][:chef][:server_log]  = "STDOUT"
  default[:bootstrap][:chef][:indexer_log] = "STDOUT"
else
  default[:bootstrap][:chef][:client_log]  = "#{bootstrap[:chef][:log_dir]}/client.log"
  default[:bootstrap][:chef][:server_log]  = "#{bootstrap[:chef][:log_dir]}/server.log"
  default[:bootstrap][:chef][:indexer_log] = "#{bootstrap[:chef][:log_dir]}/indexer.log"
end

default[:bootstrap][:chef][:server_fqdn]    = domain ? "chef.#{domain}" : "chef"
default[:bootstrap][:chef][:server_ssl_req] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{bootstrap[:chef][:server_fqdn]}/emailAddress=ops@#{domain}"
