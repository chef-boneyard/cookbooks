#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
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
  cwd "#{node[:runit][:sv_dir]}/public-dnscache"
  command "#{node[:djbdns][:bin_dir]}/dnsip `#{node[:djbdns][:bin_dir]}/dnsqr ns . | awk '/answer:/ { print \$5 ; }' | sort` > root/servers/@"
  action :nothing
end

execute "#{node[:djbdns][:bin_dir]}/dnscache-conf dnscache dnslog #{node[:runit][:sv_dir]}/public-dnscache #{node[:djbdns][:public_dnscache_ipaddress]}" do
  only_if "/usr/bin/test ! -d #{node[:runit][:sv_dir]}/public-dnscache"
  notifies :run, resources("execute[public_cache_update]")
end

runit_service "public-dnscache"

file "#{node[:runit][:sv_dir]}/public-dnscache/root/ip/#{node[:djbdns][:public_dnscache_allowed_networks]}" do
  mode 0644
end

template "#{node[:runit][:sv_dir]}/public-dnscache/root/servers/#{node[:djbdns][:tinydns_internal_resolved_domain]}" do
  source "dnscache-servers.erb"
  mode 0644
end
