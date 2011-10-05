#
# Cookbook Name:: ntp
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

case node[:platform] 
when "ubuntu","debian"
  package "ntpdate" do
    action :install
  end
end

package "ntp" do
  action :install
end

service node[:ntp][:service] do
  action :start
end

directory "/var/log/ntpstats" do
  owner "ntp"
  group "ntp"
  mode "0755"
  action :create
  notifies :restart, resources(:service => node[:ntp][:service])
end

wallclock="/proc/sys/xen/independent_wallclock"
bash "Disabling wall clock for xen hypervisors" do
  only_if { ::File.directory?("/proc/xen") && ( !::File.exists?(wallclock) || ::File.open(wallclock,"r"){|f| f.read} !~ /^1/ ) }
  code <<-EOH
    echo 1 > #{wallclock}
  EOH
  notifies :restart, resources(:service => node[:ntp][:service])
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => node[:ntp][:service])
end
