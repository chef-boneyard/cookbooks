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

user "axfrdns" do
  uid 9996
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

execute "/usr/local/bin/axfrdns-conf axfrdns dnslog /etc/axfrdns /etc/tinydns #{node[:djbdns][:axfrdns_ipaddress]}" do
  only_if "/usr/bin/test ! -d /etc/axfrdns"
end

template "/etc/axfrdns/run" do
  source "sv-axfr-run.erb"
  mode 0755
end

template "/etc/axfrdns/log/run" do
  source "sv-axfr-log-run.erb"
  mode 0755
end

link "#{node[:runit_service_dir]}/axfrdns" do
  to "/etc/axfrdns"
end

link "/etc/init.d/axfrdns" do
  to node[:runit_sv_bin]
end