#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: djbdns
# Recipe:: cache
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

execute "public_cache_update" do
  cwd "/etc/public-dnscache"
  command "#{node[:djbdns][:bin_dir]}/dnsip `#{node[:djbdns][:bin_dir]}/dnsqr ns . | awk '/answer:/ { print \$5 ; }' | sort` > root/servers/@"
  action :nothing
end

execute "#{node[:djbdns][:bin_dir]}/dnscache-conf dnscache dnslog /etc/public-dnscache #{node[:djbdns][:public_dnscache_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/public-dnscache"
  notifies :run, resources("execute[public_cache_update]")
end

template "/etc/public-dnscache/run" do
  source "sv-cache-run.erb"
  mode 0755
end

template "/etc/public-dnscache/log/run" do
  source "sv-cache-log-run.erb"
  mode 0755
end

link "#{node[:runit_service_dir]}/public-dnscache" do
  to "/etc/public-dnscache"
end

link "/etc/init.d/public-dnscache" do
  to node[:runit_sv_bin]
end
