#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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

include_recipe "mysql::client"

package "mysql-server" do
  action :install
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

if (node[:ec2] && ! FileTest.directory?(node[:mysql_ec2_path]))
  
  mysql_server_path = ""
  
  case node[:platform]
  when "ubuntu","debian"
    mysql_server_path = "/var/lib/mysql"
  else
    mysql_server_path = "/var/mysql"
  end
  
  service "mysql" do
    supports :status => true, :restart => true, :reload => true
    action :stop
  end
  
  execute "install-mysql" do
    command "mv #{mysql_server_path} #{node[:mysql_ec2_path]}"
    not_if do FileTest.directory?(node[:mysql_ec2_path]) end
  end
  
  link node[:mysql_ec2_path] do
    target_file mysql_server_path
  end
  
  service "mysql" do
    supports :status => true, :restart => true, :reload => true
    action :start
  end
  
end