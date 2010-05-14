#
# Cookbook Name:: tomcat6
# Recipe:: default
#
# Copyright 2009, Edmund Haselwanter
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

#include_recipe "java"

service "tomcat6" do
  action :nothing
end

group node[:tomcat6][:user] do
end

user node[:tomcat6][:user] do
  comment "Apache Tomcat"
  gid node[:tomcat6][:user]
  home node[:tomcat6][:home]
  shell "/bin/sh"
end

[node[:tomcat6][:temp],node[:tomcat6][:logs],node[:tomcat6][:webapps],node[:tomcat6][:home],node[:tomcat6][:conf]].each do |dir|
  directory dir do
    action :create
    mode 0755
    owner "#{node[:tomcat6][:user]}"
    group "#{node[:tomcat6][:user]}"
  end
end

[:temp,:logs,:webapps,:conf].each do |dir|
  link File.join(node[:tomcat6][:home],dir.to_s) do
    to node[:tomcat6][dir] # use values from attributes
  end
end

usr_share_dir =  "/usr/share"

bash "update_manager" do
  user node[:tomcat6][:user]
  action :nothing
  cwd node[:tomcat6][:webapps]
  code <<-EOH
  rm -rf ./manager
  cp -r #{usr_share_dir}/apache-tomcat-#{node[:tomcat6][:version]}/webapps/manager .
  EOH
end

bash "install_tomcat6" do
  tomcat_version_name = "apache-tomcat-#{node[:tomcat6][:version]}"
  tomcat_version_name_tgz = "#{tomcat_version_name}.tar.gz"
  user "root"
  cwd usr_share_dir
  not_if do File.exists?(File.join(usr_share_dir,tomcat_version_name)) end
  code <<-EOH
  wget http://archive.apache.org/dist/tomcat/tomcat-6/v#{node[:tomcat6][:version]}/bin/#{tomcat_version_name_tgz}
  tar -zxf #{tomcat_version_name_tgz}
  rm #{tomcat_version_name_tgz}
  chown -R #{node[:tomcat6][:user]}:#{node[:tomcat6][:user]} #{tomcat_version_name}
  EOH
end

# just to have it here, may be overriden through own configuration
bash "install_tomcat6_etc" do
  user node[:tomcat6][:user]
  not_if do File.exists?(File.join(node[:tomcat6][:conf],"tomcat6.conf")) end
  cwd node[:tomcat6][:conf]
  code <<-EOH
  cp -r #{usr_share_dir}/apache-tomcat-#{node[:tomcat6][:version]}/conf/* .
  EOH
end

link File.join(node[:tomcat6][:home],"lib") do
  to File.join(usr_share_dir,"apache-tomcat-#{node[:tomcat6][:version]}","lib")
  notifies :run, resources(:bash => "update_manager"), :immediately
  notifies :restart, resources(:service => "tomcat6"), :delayed
end

link File.join(node[:tomcat6][:home],"bin") do
  to File.join(usr_share_dir,"apache-tomcat-#{node[:tomcat6][:version]}","bin")
  notifies :restart, resources(:service => "tomcat6"), :delayed
end

case node[:platform]
when "centos"

  #  remote_file "/etc/yum.repos.d/rightscale.repo" do
  #    source "rightscale.repo"
  #    mode 0755
  #    owner "root"
  #    group "root"
  #  end
  #
  #  package "tomcat6"
  #
  #  link "/usr/share/java/tomcat6/\[ecj\].jar" do
  #    to "/usr/share/java/eclipse-ecj.jar"
  #  end
  #

  #  package "tomcat6-admin-webapps"

  r = remote_file "/tmp/JVM-MANAGEMENT-MIB.mib" do
    source "JVM-MANAGEMENT-MIB.mib"
    mode 0755
    owner "root"
    group "root"
  end

  r.run_action(:create)

  p = package "libsmi" do
    action :install
  end

  p.run_action(:install)

  g = gem_package "snmp" do
    action :install
  end

  g.run_action(:install)

  require 'rubygems'
  Gem.clear_paths

  require "snmp"

  SNMP::MIB.import_module("/tmp/JVM-MANAGEMENT-MIB.mib")

  package "tomcat-native" do
    action :install
    only_if do @node[:tomcat6][:with_native] end
  end


else

end

remote_file "/etc/init.d/tomcat6" do
  source "tomcat6"
  mode 0755
  owner "root"
  group "root"
end

remote_file "/usr/bin/dtomcat6" do
  source "dtomcat6"
  mode 0755
  owner "root"
  group "root"
end

remote_file File.join(node[:tomcat6][:dir],"logging.properties") do
  source "logging.properties"
  mode 0644
  owner "root"
  group "root"
end

service "tomcat6" do
  case node[:platform]
  when "centos"
    service_name "tomcat6"
  else
    name "tomcat"
  end
  supports :start=> true, :stop => true, :restart => true, :status => true
  action :enable
end

template "#{node[:tomcat6][:dir]}/tomcat6.conf" do
  source "tomcat6.conf.erb"
  group "#{node[:tomcat6][:user]}"
  owner "#{node[:tomcat6][:user]}"
  mode 0644
  notifies :stop, resources(:service => "god"), :immediately
  notifies :restart, resources(:service => "tomcat6"), :immediately
end

service "tomcat6" do
  action :start
end
