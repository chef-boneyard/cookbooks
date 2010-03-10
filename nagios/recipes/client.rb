#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Cookbook Name:: nagios
# Recipe:: client
#
# Copyright 2009, 37signals
# Copyright 2009-2010, Opscode, Inc
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
mon_host = Array.new

search(:node, "role:monitoring") do |n|
  mon_host << n['ipaddress']
end

%w{
  nagios-nrpe-server
  nagios-plugins
  nagios-plugins-basic
  nagios-plugins-standard
}.each do |pkg|
  package pkg
end

service "nagios-nrpe-server" do
  action :enable
  supports :restart => true, :reload => true
end

remote_file "/usr/lib/nagios/plugins/check_mem.sh" do
  source "plugins/check_mem.sh"
  owner "nagios"
  group "nagios"
  mode 0755
end

template "/etc/nagios/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "nagios"
  group "nagios"
  mode "0644"
  variables :mon_host => mon_host
  notifies :restart, resources(:service => "nagios-nrpe-server")
end
