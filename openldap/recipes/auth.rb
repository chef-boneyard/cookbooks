#
# Cookbook Name:: openldap
# Recipe:: auth
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "openldap::client"
include_recipe "openssh"
include_recipe "nscd"

package "libnss-ldap" do
  action :upgrade
end

package "libpam-ldap" do
  action :upgrade
end

template "/etc/ldap.conf" do
  source "ldap.conf.erb"
  mode 0644
  owner "root"
  group "root"
end    

template "/etc/ldap/ldap.conf" do
  source "ldap-ldap.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/etc/nsswitch.conf" do
  source "nsswitch.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "nscd"), :immediately
  notifies :run, resources(:execute => [ "nscd-clear-passwd", "nscd-clear-group" ]), :immediately
end

%w{ account auth password session }.each do |pam|
  cookbook_file "/etc/pam.d/common-#{pam}" do
    source "common-#{pam}"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, resources(:service => "ssh"), :delayed
  end
end

template "/etc/security/login_access.conf" do
  source "login_access.conf.erb"
  mode 0644
  owner "root"
  group "root"
end
