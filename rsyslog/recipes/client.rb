#
# Cookbook Name:: rsyslog
# Recipe:: client
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

rsyslog_server = node[:rsyslog][:server] ? node[:rsyslog][:server] : search(:node, "rsyslog_server:true", nil, 0, 1)

unless node[:rsyslog][:server] 
  template "/etc/rsyslog.d/remote.conf" do
    source "remote.conf.erb"
    backup false
    variables(
      :server => rsyslog_server['fqdn'],
      :protocol => node[:rsyslog][:protocol]
    )
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "rsyslog"), :delayed
  end

  file "/etc/rsyslog.d/server.conf" do
    action :delete
    notifies :reload, resources(:service => "rsyslog"), :delayed
    only_if do File.exists?("/etc/rsyslog.d/server.conf") end
  end
end
