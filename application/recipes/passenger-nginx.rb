#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

app = node.run_state[:current_app] 

include_recipe "passenger_enterprise::nginx"

template "#{node[:nginx][:dir]}/sites-available/#{app['id']}.conf" do
  source "rails_nginx_passenger.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :app => app['id'],
    :docroot => "/srv/#{app['id']}/current/public",
    :server_name => "#{app['id']}.#{node[:domain]}",
    :server_aliases => [ node[:fqdn], app['id'] ],
    :rails_env => app['environment']
  )
end

nginx_site "#{app['id']}.conf" do
  notifies :restart, resources(:service => "nginx")
end

d = resources(:deploy => app['id'])
d.restart_command do
  service "nginx" do action :restart; end
end

