#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "cron"
include_recipe "rsyslog"

node.set[:rsyslog][:server] = true

unless Chef::Config[:solo]
  node.save
end

directory node[:rsyslog][:log_dir] do
  owner "root"
  group "root"
  mode 0755
end

template "/etc/rsyslog.d/server.conf" do
  source "server.conf.erb"
  backup false
  variables(
    :log_dir => node[:rsyslog][:log_dir],
    :protocol => node[:rsyslog][:protocol]
  )
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rsyslog"), :delayed
end

file "/etc/rsyslog.d/remote.conf" do
  action :delete
  backup false
  notifies :reload, resources(:service => "rsyslog"), :delayed
  only_if do ::File.exists?("/etc/rsyslog.d/remote.conf") end
end

cron "rsyslog_gz" do
  command "find #{node[:rsyslog][:log_dir]}/$(date +\\%Y) -type f -mtime +1 -exec gzip -q {} \\;"
  minute "0"
  hour "4"
end
