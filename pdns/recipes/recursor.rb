#
# Cookbook Name:: pdns
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

package "pdns-recursor"

service "pdns-recursor" do
  action [:enable, :start]
end

case node["platform"]
when "arch"
  user "pdns" do
    shell "/bin/false"
    home "/var/spool/powerdns"
    supports :manage_home => true
    system true
  end
end

template "/etc/powerdns/recursor.conf" do
  source "recursor.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resource(:service => "pdns-recursor"), :immediately
end
