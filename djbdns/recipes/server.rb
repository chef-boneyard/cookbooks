#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: djbdns
# Recipe:: server
#
# Copyright 2009, Opscode, Inc
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
include_recipe "djbdns"

execute "#{node[:djbdns][:bin_dir]}/tinydns-conf tinydns dnslog /etc/tinydns #{node[:djbdns][:tinydns_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/tinydns"
end

execute "build-tinydns-data" do
  cwd "/etc/tinydns/root"
  command "make"
  action :nothing
end

template "/etc/tinydns/root/data" do
  source "tinydns-data.erb"
  mode 644
  notifies :run, resources("execute[build-tinydns-data]")
end

template "/etc/tinydns/run" do
  source "sv-server-run.erb"
  mode 0755
end

template "/etc/tinydns/log/run" do
  source "sv-server-log-run.erb"
  mode 0755
end

link "#{node[:runit_service_dir]}/tinydns" do
  to "/etc/tinydns"
end

link "/etc/init.d/tinydns" do
  to node[:runit_sv_bin]
end
