#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "rsyslog"

directory "/srv/rsyslog" do
  owner "root"
  group "root"
  mode 0755
end

template "/etc/rsyslog.d/server.conf" do
  source "server.conf.erb"
  variables :log_dir => node[:rsyslog][:log_dir]
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "rsyslog"), :delayed
end

cron "rsyslog_gz" do
  minute "0"
  hour "4"
  command "find #{node[:rsyslog][:log_dir]}/`date +%Y` -type f -mtime +1 -exec gzip {} \;"
end
