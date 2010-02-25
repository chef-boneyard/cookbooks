#
# Cookbook Name:: munin
# Recipe:: server
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

include_recipe "apache2"
include_recipe "apache2::mod_auth_openid"
include_recipe "apache2::mod_rewrite"
include_recipe "munin::client"

package "munin"

remote_file "/etc/cron.d/munin" do
  source "munin-cron"
  mode "0644"
  owner "root"
  group "root"
  backup 0
end

munin_servers = search(:node, "hostname:[* TO *] AND role:#{node[:app_environment]}")

if node[:public_domain]
  case node[:app_environment]
  when "production"
    public_domain = node[:public_domain]
  else
    public_domain = "#{node[:app_environment]}.#{node[:public_domain]}"
  end
else
  public_domain = node[:domain]
end

template "/etc/munin/munin.conf" do
  source "munin.conf.erb"
  mode 0644
  variables(:munin_nodes => munin_servers)
end

apache_site "000-default" do
  enable false
end

template "#{node[:apache][:dir]}/sites-available/munin.conf" do
  source "apache2.conf.erb"
  mode 0644
  variables :public_domain => public_domain
  if File.symlink?("#{node[:apache][:dir]}/sites-enabled/munin.conf")
    notifies :reload, resources(:service => "apache2")
  end
end

apache_site "munin.conf"
