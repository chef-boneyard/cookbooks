#
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Cookbook Name:: nagios
# Recipe:: client_xinetd
#
# Copyright 2011 
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

mon_host = ['127.0.0.1']

if node['nagios_server']
  mon_host << node['nagios_server']
elsif node.run_list.roles.include?(node['nagios']['server_role'])
  mon_host << node['ipaddress']
else
  search(:node, "role:#{node['nagios']['server_role']} AND chef_environment:#{node.chef_environment}") do |n|
    mon_host << n['ipaddress']
  end
end

# find out nagios user's sudo commands
search(:users, "id:#{node['nagios']['user']}").each do |item|
  sudo_cmds =  item[:sudo_cmds]
end

# some of the nagios plugins require this package
if platform? ["centos", "redhat", "ubuntu" ]
  package "sysstat"
end

include_recipe "nagios::client_#{node['nagios']['client']['install_method']}"

package "xinetd"

service "xinetd" do
  action [:enable, :start]
end

# disable the service, we are using xinetd instead
service "nagios-nrpe-server" do
  action :disable
end


remote_directory node['nagios']['plugin_dir'] do
  source "plugins"
  owner "root"
  group "root"
  mode 0755
  files_mode 0755
end

template "#{node['nagios']['nrpe']['conf_dir']}/nrpe.cfg" do
  source "nrpe.xinetd.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :mon_host => mon_host
end

# add sudoers
if defined? sudo_cmds
  template "/etc/sudoers.d/nagios" do
    source "nagios_sudoers.erb"
    owner "root"
    group "root"
    variables( :sudo_cmds => sudo_cmds)
    mode "0440"
  end
end

template "/etc/xinetd.d/nrpe" do
  source "nrpe.xinetd.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :mon_host => mon_host )
  notifies :restart, "service[xinetd]"
end

# xinetd won't load nrpe on rhel 5-6 w/out this
execute "etc_services_entry" do
  command "echo 'nrpe  5666/tcp      # nrpe' >> /etc/services"
  returns 0
  not_if "egrep '^nrpe.*$' /etc/services"
end
