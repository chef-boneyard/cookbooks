#
# Cookbook Name:: passenger_enterprise
# Recipe:: nginx
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
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
include_recipe "passenger_enterprise"

configure_flags = node[:nginx][:configure_flags].join(" ")
nginx_install = node[:nginx][:install_path]
nginx_version = node[:nginx][:version]
nginx_dir = node[:nginx][:dir]

execute "passenger_nginx_module" do
  command %Q{
    #{node[:ruby_enterprise][:install_path]}/bin/passenger-install-nginx-module \
      --auto --prefix=#{nginx_install} \
      --nginx-source-dir=/tmp/nginx-#{nginx_version} \
      --extra-configure-flags='#{configure_flags}'
  }
  not_if "#{nginx_install}/sbin/nginx -V 2>&1 | grep '#{node[:ruby_enterprise][:gems_dir]}/gems/passenger-#{node[:passenger_enterprise][:version]}/ext/nginx'"
  notifies :restart, resources(:service => "nginx")
end

template "#{nginx_dir}/conf.d/passenger.conf" do
  source "passenger_nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end
