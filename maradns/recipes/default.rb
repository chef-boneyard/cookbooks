#
# Cookbook Name:: maradns
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

package "maradns" do
  action :upgrade
end

service "maradns" do
  action :enable
  supports(
    :restart => true,
    :status => true
  )
end

service "zoneserver" do
  action :disable
  supports :restart => true
end

template "/etc/maradns/mararc" do
  source "mararc.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "maradns")
end

# be sure to create the db.domain template.
template "/etc/maradns/db.#{node[:domain]}" do
  source "db.#{node[:domain]}.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "maradns")
end  
