#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: chrony
# Recipe:: master
#
# Copyright 2011, Opscode, Inc
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

package "chrony"

service "chrony" do
  supports :restart => true, :status => true, :reload => true
  action [ :enable ]
end

#set the allowed hosts to the subnet
#ip = node.ipaddress.split('.')
#set the allowed hosts to the class B
#node[:chrony][:allow] = ["allow #{ip[0]}.#{ip[1]}"]

#if there are NTP servers, use the first 3 for the initslew
if node[:chrony][:servers].length > 0
  node[:chrony][:initslewstep] = "initslewstep 10"
  keys = node[:chrony][:servers].keys.sort
  count = 3
  count = keys.length if keys.length < count
  count.times {|x| node[:chrony][:initslewstep] += " #{keys[x]}" }
else #else use first 3 clients
  clients = search(:node, 'recipes:chrony\:\:client').sort || []
  if clients.length > 0
    node[:chrony][:initslewstep] = "initslewstep 10"
    count = 3
    count = clients.length if clients.length < count
    count.times {|x| node[:chrony][:initslewstep] += " #{clients[x].ipaddress}" }
  end
end

template "/etc/chrony/chrony.conf" do
  owner "root"
  group "root"
  mode 0644
  source "chrony.conf.erb"
  notifies :restart, "service[chrony]"
end

