#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: djbdns
# Recipe:: internal_server
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

execute "#{node[:djbdns][:bin_dir]}/tinydns-conf tinydns dnslog #{node[:runit][:sv_dir]}/tinydns-internal #{node[:djbdns][:tinydns_ipaddress]}" do
  only_if "/usr/bin/test ! -d #{node[:runit][:sv_dir]}/tinydns-internal"
end

execute "build-tinydns-internal-data" do
  cwd "#{node[:runit][:sv_dir]}/tinydns-internal/root"
  command "make"
  action :nothing
end

template "#{node[:runit][:sv_dir]}/tinydns-internal/root/data" do
  source "tinydns-internal-data.erb"
  mode 0644
  notifies :run, resources("execute[build-tinydns-internal-data]")
end

runit_service "tinydns-internal"
