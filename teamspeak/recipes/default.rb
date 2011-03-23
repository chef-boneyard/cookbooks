#
# Author:: Joshua Timberman <joshua@housepub.org>
# Cookbook Name:: teamspeak
# Recipe:: default
#
# Copyright 2008-2009, Joshua Timberman
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

package "teamspeak-server"

service "teamspeak-server" do
  action :enable
end

ts_server = "teamspeak.#{node[:domain]}"

template "/etc/teamspeak-server/server.ini" do
  source "server.ini.erb"
  owner "teamspeak-server"
  group "teamspeak-server"
  mode "0600"
end

include_recipe "php"
include_recipe "apache2::mod_php5"

directory "/srv/www/tsdisplay" do
  action :create
  recursive true
  owner "www-data"
  group "www-data"
  mode "755"
end

bash "install tsdisplay" do
  cwd "/srv/www/tsdisplay"
  code <<-EOH
wget http://softlayer.dl.sourceforge.net/sourceforge/tsdisplay/TeamspeakDisplay-PR3.zip
unzip TeamSpeakDisplay-PR3.zip  
EOH
  not_if { ::File.exists?("/srv/www/tsdisplay/TeamspeakDisplay-PR3.zip") }
end

template "/srv/www/tsdisplay/demo.php" do
  source "demo.php.erb"
  owner "www-data"
  group "www-data"
  mode "644"
  variables :ts_server => ts_server
end

template "/etc/apache2/sites-available/teamspeak.conf" do
  source "teamspeak.conf.erb"
  owner "root"
  group "root"
  mode "644"
  variables :virtual_host_name => ts_server, :docroot => "/srv/www/tsdisplay"
end

apache_site "teamspeak.conf" do
  enable :true
end
