#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Recipe:: server
#
# Copyright 2010, Zenoss, Inc
# Copyright 2010, 2011 Opscode, Inc
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

include_recipe "zenoss::client"

case node[:platform]
when "centos","redhat","scientific"
  include_recipe "yum"
  
  yum_key "RPM-GPG-KEY-zenoss" do
    url "http://dev.zenoss.com/yum/RPM-GPG-KEY-zenoss"
    action :add
  end
  
  yum_repository "zenoss" do
    description "Zenoss Stable repo"
    key "RPM-GPG-KEY-zenoss"
    url "http://dev.zenoss.com/yum/stable/"
    failovermethod "priority"
    action :add
  end
  
  packages = %w{mysql-server net-snmp net-snmp-utils gmp libgomp libgcj liberation-fonts}
  packages.each do |pkg|
    yum_package pkg do
      action :install
    end
  end

  #mysql setup from the installation guide, this should be replaced with proper use of mysql::server
  service "mysqld" do
    action [:enable, :start]
  end

  execute "/usr/bin/mysqladmin -u root password ''"
  execute "/usr/bin/mysqladmin -u root -h localhost password ''"

  #from the install guide, would be worthwhile to configure properly
  service "iptables" do
    action [:stop, :disable]
  end

  yum_package "zenoss" do
    action :install
  end

  #end redhat/centos/scientific block
when "debian","ubuntu"
  include_recipe "apt"
  
  apt_repository "zenoss" do
    uri "http://dev.zenoss.org/deb"
    distribution "main"
    components ["stable"]
    action :add
  end
  
  packages = %w{ttf-liberation ttf-linux-libertine}
  packages.each do |pkg|
    apt_package pkg do
      action :install
    end
  end
  
  #Zenoss hasn't signed their repository http://dev.zenoss.org/trac/ticket/7421
  apt_package "zenoss-stack" do
    version node["zenoss"]["server"]["version"]
    options "--allow-unauthenticated"
    action :install
  end
  #end of debian/ubuntu
end


#apply post 3.1.0 patches from http://dev.zenoss.com/trac/report/6 marked 'closed'
node["zenoss"]["server"]["zenpatches"].each do |patch, url| 
  zenoss_zenpatch patch do
    ticket url
    action :install
  end
end

#the Zenoss installer puts the service in place, just start it
service "zenoss" do
  case node["platform"]
  when "debian", "ubuntu"
    service_name "zenoss-stack"
  when "redhat", "centos", "scientific"
    service_name "zenoss"
  end
    action [:enable, :start ]
end

#skip the new install Wizard.
zenoss_zendmd "skip setup wizard" do
  command "dmd._rq = True"
  action :run
end

#use zendmd to set the admin password
zenoss_zendmd "set admin pass" do
  command "app.acl_users.userManager.updateUserPassword('admin', '#{node[:zenoss][:server][:admin_password]}')"
  action :run
end

#search the 'users' databag and pull out sysadmins for users and groups
begin
  admins = search(:users, 'groups:sysadmin') || []
rescue
  admins = []
end
zenoss_zendmd "add users" do
  users admins
  action :users
end

#put public key in an attribute
ruby_block "zenoss public key" do
  block do
    pubkey = IO.read("/home/zenoss/.ssh/id_dsa.pub")
    node.set["zenoss"]["server"]["zenoss_pubkey"] = pubkey
    node.save
    #write out the authorized_keys for the zenoss user
    ak = File.new("/home/zenoss/.ssh/authorized_keys", "w+")
    ak.puts pubkey
    ak.chown(File.stat("/home/zenoss/.ssh/id_dsa.pub").uid,File.stat("/home/zenoss/.ssh/id_dsa.pub").gid)
  end
  action :nothing
end

#generate SSH key for the zenoss user
execute "ssh-keygen -q -t dsa -f /home/zenoss/.ssh/id_dsa -N \"\" " do
  user "zenoss"
  action :run
  not_if {File.exists?("/home/zenoss/.ssh/id_dsa.pub")}
  notifies :create, resources(:ruby_block => "zenoss public key"), :immediate
end

#this list should get appended by other recipes
node["zenoss"]["server"]["installed_zenpacks"].each do |package, zpversion| 
  zenoss_zenpack "#{package}" do
    version zpversion
    action :install
    notifies :restart, resources(:service => "zenoss"), :immediate
  end
end

#find the roles and push their settings in via zendmd
deviceclasslist = []
locationlist = []
grouplist = []
search(:role, "*:*").each do |role|
  if role.override_attributes["zenoss"] and role.override_attributes["zenoss"]["device"] 
    if role.override_attributes["zenoss"]["device"]["device_class"]
      #add the role as a Device Class
      deviceclasslist.push(role.name)
      zenoss_zendmd role.override_attributes["zenoss"]["device"]["device_class"] do
        description role.description
        modeler_plugins role.default_attributes["zenoss"]["device"]["modeler_plugins"]
        templates role.default_attributes["zenoss"]["device"]["templates"]
        properties role.default_attributes["zenoss"]["device"]["properties"]
        action :deviceclass
      end
    elsif role.override_attributes["zenoss"]["device"]["location"]
      #add the role as a Location
      locationlist.push(role.name)
      zenoss_zendmd role.name do
        location role.override_attributes["zenoss"]["device"]["location"]
        description role.description
        address role.override_attributes["zenoss"]["device"]["address"]
        action :location
      end
    end
  else
    #create Groups for the rest of the roles
    grouplist.push(role.name)
    zenoss_zendmd role.name do
      description role.description
      action :group
    end
  end
end

#move the localhost to SSH monitoring since we're not using SNMP
zenoss_zendmd "move Zenoss server" do
  batch = "dmd.Devices.moveDevices('/Server/SSH/Linux/MySQL', '#{node[:fqdn]}')\n"
  batch += "dev = dmd.Devices.findDevice('#{node[:fqdn]}')\n"
  batch += "dev.setManageIp('#{node[:ipaddress]}')"
  command batch
  action :run
end

#all nodes (for now, until pick a role or other flag to standardize on)
nodes = search(:node, 'zenoss:device*') || []
#find the recipes and create Systems for them
systems = []
nodes.each {|node| systems.push(node.expand!.recipes)}
systems.flatten!
systems.uniq!
#make suborganizers with recipes
systems.collect! {|sys| sys.gsub('::', '/')}
systems.each do |system|
  zenoss_zendmd system do
    action :system
  end
end
#using the nodes list, write out a zenbatchload 
#find all the device classes and the devices each one has.
devices = {}
nodes.each do |node|
  if node.attribute["zenoss"] and node.attribute["zenoss"]["device"]
    dclass = node.attribute["zenoss"]["device"]["device_class"]
    if devices.has_key?(dclass)
      devices[dclass].push(node)
    else
      devices[dclass] = [node]
    end
  end
end
zenoss_zenbatchload "zenbatchloading devices" do
  devices devices
  locations locationlist
  groups grouplist
  action :run
end

#keep the previous zenbatchload run, diff it against the new list and only load the results of the diff.
