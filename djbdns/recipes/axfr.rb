#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: djbdns
# Recipe:: axfr
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

user "axfrdns" do
  uid node[:djbdns][:axfrdns_uid]
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/axfrdns"
end

execute "#{node[:djbdns][:bin_dir]}/axfrdns-conf axfrdns dnslog #{node[:djbdns][:axfrdns_dir]} #{node[:djbdns][:tinydns_dir]} #{node[:djbdns][:axfrdns_ipaddress]}" do
  not_if { ::File.directory?(node[:djbdns][:axfrdns_dir]) }
end

case node[:djbdns][:service_type]
when "runit"
  link "#{node[:runit][:sv_dir]}/axfrdns" do
    to node[:djbdns][:axfrdns_dir]
  end
  runit_service "axfrdns"
when "bluepill"
  bluepill_service "axfrdns" do
    action [:enable,:load,:start]
  end
when "daemontools"
  daemontools_service "axfrdns" do
    directory node[:djbdns][:axfrdns_dir]
    template false
    action [:enable,:start]
  end
end
