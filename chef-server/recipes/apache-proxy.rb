#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef-server
# Recipe:: apache-proxy
#
# Copyright 2009-2011, Opscode, Inc
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

node['apache']['listen_ports'] << "443" unless node['apache']['listen_ports'].include?("443")
if node['chef_server']['webui_enabled']
  node['apache']['listen_ports'] << "444" unless node['apache']['listen_ports'].include?("444")
end

include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_proxy_balancer"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_deflate"

directory "/etc/chef/certificates" do
  owner "chef"
  group root_group
  mode "700"
end

bash "Create SSL Certificates" do
  cwd "/etc/chef/certificates"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > chef-server-proxy.key
  openssl req -subj "#{node['chef_server']['ssl_req']}" -new -x509 -nodes -sha1 -days 3650 -key chef-server-proxy.key > chef-server-proxy.crt
  cat chef-server-proxy.key chef-server-proxy.crt > chef-server-proxy.pem
  EOH
  not_if { ::File.exists?("/etc/chef/certificates/chef-server-proxy.pem") }
end

web_app "chef-server-proxy" do
  template "chef_server.conf.erb"
  server_name "localhost"
  server_aliases [ node['hostname'], node['fqdn'], 'chef-server-proxy', "chef.#{node['domain']}" ]
  log_dir node['apache']['log_dir']
end
