#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: chrony
# Recipe:: client
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

#clients aren't servers by default
node.default[:chrony][:allow] = []

#search for the chrony master(s), if found populate the template accordingly
#typical deployment will only have 1 master, but still allow for multiple
masters = search(:node, 'recipes:chrony\:\:master') || []
if masters.length > 0
  node.default[:chrony][:servers] = {}
  masters.each do |master|
    node[:chrony][:servers][master.ipaddress] = master[:chrony][:server_options]
    node[:chrony][:allow].push "allow #{master.ipaddress}"
    #only use 1 server to sync initslewstep
    node[:chrony][:initslewstep] = "initslewstep 20 #{master.ipaddress}"
  end
else
  Chef::Log.info("No chrony master(s) found, using node[:chrony][:servers] attribute.")
end

template "/etc/chrony/chrony.conf" do
  owner "root"
  group "root"
  mode 0644
  source "chrony.conf.erb"
  notifies :restart, "service[chrony]"
end
