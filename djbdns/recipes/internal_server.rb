#
# Cookbook Name:: djbdns
# Recipe:: default
# Author:: Joshua Timberman (<joshua@opscode.com>)
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

execute "/usr/local/bin/tinydns-conf tinydns dnslog /etc/tinydns #{node[:djbdns][:tinydns_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/tinydns-internal"
end

template "/etc/tinydns-internal/root/data" do
  source "tinydns-internal-data.erb"
  mode 644
  notifies :action, resources("execute[build-tinydns-internal-data]")
end

execute "build-tinydns-internal-data" do
  cwd "/etc/tinydns-internal/root"
  command "make"
  notify_only true
end

template "/etc/tinydns-internal/run" do
  source "sv-server-run.erb"
  mode 0755
end

template "/etc/tinydns-internal/log/run" do
  source "sv-server-log-run.erb"
  mode 0755
end

link "#{node[:runit_service_dir]}/tinydns-internal" do
  to "/etc/tinydns-internal"
end

link "/etc/init.d/tinydns-internal" do
  to node[:runit_sv_bin]
end
