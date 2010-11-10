#
# Cookbook Name:: pacemaker
# Recipe:: default
#
# Copyright 2010, Sean Carey <sean@densone.com>
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

#do not write a function to autmatically restart heartbeat. 
#This is a bad idea and could create and extremely nagative system reaction

db_pacemaker = data_bag_item(node[:pacemaker][:databag][:name], node[:pacemaker][:databag][:id])

package "heartbeat" do
  action :install
end

package "pacemaker" do
  action :install
end


template "/etc/heartbeat/ha.cf" do
  source "ha.cf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:ha_conf => db_pacemaker)
end

template "/etc/heartbeat/authkeys" do
  source "authkeys.erb"
  mode 0600
  owner "root"
  group "root"
  variables(:ha_conf => db_pacemaker)
end

service "heartbeat" do
  supports :restart => true, :reload => true
  action :enable
end