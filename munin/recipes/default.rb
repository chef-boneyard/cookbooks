#
# Cookbook Name:: munin
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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

package "munin-node" 

service "munin-node" do
  supports :restart => true
  action :enable
end

munin_server_regexs = []
search(:nodes, "munin_server_regex:*").each do |ip|
  munin_server_regexs << ip unless munin_server_regexs.detect? { |i| i == ip }
end

template "/etc/munin/munin-node.conf" do
  source "munin-node.conf.erb"
  mode 0644
  variables :munin_server_regexs => munin_server_regexs
  notifies :restart, resources(:service => "munin-node")
end
