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
  cwd "#{node[:djbdns][:public_dnscache_dir]}"
  command "#{node[:djbdns][:bin_dir]}/dnsip `#{node[:djbdns][:bin_dir]}/dnsqr ns . | awk '/answer:/ { print \$5 ; }' | sort` > root/servers/@"
  action :nothing
end

execute "#{node[:djbdns][:bin_dir]}/dnscache-conf dnscache dnslog #{node[:djbdns][:public_dnscache_dir]} #{node[:djbdns][:public_dnscache_ipaddress]}" do
  not_if { ::File.directory?(node[:djbdns][:public_dnscache_dir]) }
  notifies :run, resources("execute[public_cache_update]")
end

case node[:djbdns][:service_type]
when "runit"
  link "#{node[:runit][:sv_dir]}/public-dnscache" do
    to node[:djbdns][:public_dnscache_dir]
  end
  runit_service "public-dnscache"
when "bluepill"
  template "#{node['bluepill']['conf_dir']}/public-dnscache.pill" do
    source "public-dnscache.pill.erb"
    mode 0644
  end
  bluepill_service "public-dnscache" do
    action [:enable,:load,:start]
    subscribes :restart, resources(:template => "#{node['bluepill']['conf_dir']}/public-dnscache.pill")
  end
when "daemontools"
  daemontools_service "public-dnscache" do
    directory node[:djbdns][:public_dnscache_dir]
    template false
    action [:enable,:start]
  end
end

node[:djbdns][:public_dnscache_allowed_networks].each do |net|
  file "#{node[:djbdns][:public_dnscache_dir]}/root/ip/#{net}" do
    mode 0644
  end
end

template "#{node[:djbdns][:public_dnscache_dir]}/root/servers/#{node[:djbdns][:tinydns_internal_resolved_domain]}" do
  source "dnscache-servers.erb"
  mode 0644
end
