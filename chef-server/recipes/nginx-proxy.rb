#
# Author:: Jamie Winsor <jamie@vialstudios.com>
# Cookbook Name:: chef-server
# Recipe:: nginx-proxy
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

include_recipe "nginx::source"

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

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

template "#{node[:nginx][:dir]}/sites-available/chef_server_proxy.conf" do
  source "chef_server.nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]"
  variables(
    :api_server_name => node['chef_server']['proxy']['api_server_name'],
    :api_aliases => node['chef_server']['proxy']['api_aliases'],
    :api_port => node['chef_server']['proxy']['api_port'],
    :webui_server_name => node['chef_server']['proxy']['webui_server_name'],
    :webui_aliases => node['chef_server']['proxy']['webui_aliases'],
    :webui_port => node['chef_server']['proxy']['webui_port']
  )
end

nginx_site "chef_server_proxy.conf"
