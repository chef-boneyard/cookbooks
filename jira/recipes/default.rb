#
# Cookbook Name:: jira
# Recipe:: default
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

#
# Manual Steps!
#
# MySQL:
#
#   create database jiradb character set utf8;
#   grant all privileges on jiradb.* to '$jira_user'@'localhost' identified by '$jira_password';
#   flush privileges;

include_recipe "runit"
include_recipe "java"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_ssl"
include_recipe "mysql::server"

unless FileTest.exists?(node[:jira][:install_path])
  bash "mysql-install-jira-privileges" do
    code "/usr/bin/mysql -u root -p\"#{node[:mysql][:server_root_password]}\" -e \"create database jiradb character set utf8; grant all privileges on jiradb.* to '#{node[:jira][:database_user]}'@'#{node['mysql']['bind_address']}' identified by '#{node[:jira][:database_password]}'; flush privileges;\""
  end

  remote_file "jira" do
    path "/tmp/jira.tar.gz"
    source "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-#{node[:jira][:version]}.tar.gz"
  end
  
  bash "untar-jira" do
    code "(cd /tmp; tar zxvf /tmp/jira.tar.gz)"
  end
  
  bash "install-jira" do
    code "mv /tmp/atlassian-jira-#{node[:jira][:version]}-standalone #{node[:jira][:install_path]}"
  end

  bash "install-jira-change-owner" do
    code "chown -R www-data: #{node[:jira][:install_path]}"
  end
  
  directory "#{node[:jira][:home]}" do
    owner "www-data"
    group "www-data"
  end

  if node[:jira][:database] == "mysql"
    remote_file "mysql-connector" do
      path "/tmp/mysql-connector.tar.gz"
      source "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.19.tar.gz/from/http://gd.tuwien.ac.at/db/mysql/"
    end
  
    bash "untar-mysql-connector" do
      code "(cd /tmp; tar zxvf /tmp/mysql-connector.tar.gz)"
    end
  
    bash "install-mysql-connector" do
      code "cp /tmp/mysql-connector-java-5.1.19/mysql-connector-java-5.1.19-bin.jar #{node[:jira][:install_path]}/lib"
    end
  end
end

directory "#{node[:jira][:install_path]}" do
  recursive true
  owner "www-data"
  group "www-data"
end

cookbook_file "#{node[:jira][:install_path]}/bin/startup.sh" do
  source "startup.sh"
  mode 0755
end
  
cookbook_file "#{node[:jira][:install_path]}/bin/catalina.sh" do
  source "catalina.sh"
  mode 0755
end

template "#{node[:jira][:install_path]}/atlassian-jira/dbconfig.xml" do
  source "dbconfig.xml.erb"
  owner "www-data"
  group "www-data"
  mode 0755
end
  
template "#{node[:apache][:dir]}/sites-available/jira.conf" do
  source "apache.conf.erb"
  mode 0644
end

template "#{node[:jira][:install_path]}/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source "jira-application.properties.erb"
  owner "www-data"
  group "www-data"
  mode 0644
end

apache_site "000-default" do
  enable false
end

runit_service "jira"

apache_site "jira.conf"
