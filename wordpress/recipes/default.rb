#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2009-2010, Opscode, Inc.
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
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end


remote_file "#{Chef::Config[:file_cache_path]}/wordpress-#{node['wordpress']['version']}.tar.gz" do
  checksum node['wordpress']['checksum']
  source "http://wordpress.org/wordpress-#{node['wordpress']['version']}.tar.gz"
  mode "0644"
end

directory "#{node['wordpress']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

sites = node['wordpress']['sites']

sites.each do |wp_site|
  wp_site_dir = node['wordpress'][wp_site]['dir']
  wp_site_db = node['wordpress'][wp_site]['db']['database']
  wp_site_user = node['wordpress'][wp_site]['db']['user']
  wp_site_aliases = node['wordpress'][wp_site]['server_aliases']

  node.set['wordpress'][wp_site]['db']['password'] = secure_password
  node.set['wordpress'][wp_site]['keys']['auth'] = secure_password
  node.set['wordpress'][wp_site]['keys']['secure_auth'] = secure_password
  node.set['wordpress'][wp_site]['keys']['logged_in'] = secure_password
  node.set['wordpress'][wp_site]['keys']['nonce'] = secure_password

  wp_site_db_pwd = node['wordpress'][wp_site]['db']['password']

  directory wp_site_dir do
    owner "www-data"
    group "www-data"
    mode "0755"
    action :create
    recursive true
  end

  execute "untar-wordpress" do
    cwd wp_site_dir
    command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/wordpress-#{node['wordpress']['version']}.tar.gz"
    creates "#{wp_site_dir}/wp-settings.php"
  end

  execute "mysql-install-wp-privileges" do
    command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
    action :nothing
  end

  template "#{node['mysql']['conf_dir']}/wp-grants.sql" do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
              :user     => wp_site_user,
              :password => wp_site_db_pwd,
              :database => wp_site_db
              )
    notifies :run, "execute[mysql-install-wp-privileges]", :immediately
  end

  execute "create #{wp_site_db} database" do
    command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{wp_site_db}"
    not_if do
      require 'mysql'
      m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
      m.list_dbs.include?(wp_site_db)
    end
    notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
  end

  # save node data after writing the MYSQL root password, so that a
  # failed chef-client run that gets this far doesn't cause an unknown
  # password to get applied to the box without being saved in the node
  # data.
  unless Chef::Config[:solo]
    ruby_block "save node data" do
      block do
        node.save
      end
      action :create
    end
  end

  log "Navigate to 'http://#{wp_site}/wp-admin/install.php' to complete wordpress installation" do
    action :nothing
  end

  template "#{wp_site_dir}/wp-config.php" do
    source "wp-config.php.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
              :database        => wp_site_db,
              :user            => wp_site_user,
              :password        => wp_site_db_pwd,
              :auth_key        => node['wordpress'][wp_site]['keys']['auth'],
              :secure_auth_key => node['wordpress'][wp_site]['keys']['secure_auth'],
              :logged_in_key   => node['wordpress'][wp_site]['keys']['logged_in'],
              :nonce_key       => node['wordpress'][wp_site]['keys']['nonce']
              )
    notifies :write, "log[Navigate to 'http://#{wp_site}/wp-admin/install.php' to complete wordpress installation]"
  end

  apache_site "000-default" do
    enable false
  end

  web_app wp_site do
    template "wordpress.conf.erb"
    docroot wp_site_dir
    server_name wp_site
    server_aliases wp_site_aliases
  end
end
