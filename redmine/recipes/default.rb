#
# Author: Joshua Timberman <joshua.timberman@gmail.com>
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2008, Joshua Timberman
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

case node[:redmine][:db][:type]
when "sqlite"
  include_recipe "sqlite"
  gem_package "sqlite3-ruby" 
when "mysql"
  include_recipe "mysql::client"
end

include_recipe "rails"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "passenger::mod_rails"

bash "install_redmine" do
  cwd "/srv"
  user "root"
  code <<-EOH
    wget http://rubyforge.org/frs/download.php/#{node[:redmine][:dl_id]}/redmine-#{node[:redmine][:version]}.tar.gz
    ln -sf /srv/redmine-#{node[:redmine][:version]} /srv/redmine
  EOH
end

database_server = search(:node, "database_master:true").map {|n| n['fqdn']}.first

template "/srv/redmine-#{node[:redmine][:version]}/config/database.yml" do
  owner "root"
  group "root"
  variables :database_server => database_server
  mode "0664"
end

web_app "redmine" do
  docroot "/srv/redmine/public"
  template "redmine.conf.erb"
  server_name "redmine.#{node[:domain]}"
  server_aliases [ "redmine", node[:hostname] ]
  rails_env "production"
end
