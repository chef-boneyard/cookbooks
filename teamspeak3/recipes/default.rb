#
# Author:: Joshua Timberman <joshua@housepub.org>
# Cookbook Name:: teamspeak3
# Recipe:: default
#
# Copyright 2008-2009, Joshua Timberman
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

base = "teamspeak3-server_linux-#{node[:ts3][:arch]}"
basever = "#{base}-#{node[:ts3][:version]}"

service "teamspeak3" do
  action :nothing
end

remote_file "/tmp/#{basever}.tar.gz" do
  source node[:ts3][:url]
  mode 0644
  not_if { ::FileTest.exists?("/tmp/#{basever}.tar.gz") }
end

execute "install_ts3" do
  cwd "/srv"
  command "tar zxf /tmp/#{basever}.tar.gz"
  subscribes :run, resources(:remote_file => "/tmp/#{basever}.tar.gz"), :immediately
  notifies :restart, resources(:service => "teamspeak3")
  not_if { ::FileTest.exists?("/srv/#{base}/ts3server_linux_#{node[:ts3][:arch]}") }
end

user "teamspeak-server"
group "teamspeak-server"

directory "/srv/#{base}" do
  owner "teamspeak-server"
  group "teamspeak-server"
end

link "/srv/teamspeak3" do
  to "/srv/#{base}"
end

runit_service "teamspeak3"

log "Set up teamspeak3 server. To get the server admin password and token, check the runit log." do
  action :nothing
  subscribes :write, resources(:execute => "install_ts3")
end
