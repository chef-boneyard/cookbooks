#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: server_source
#
# Copyright 2011, Opscode, Inc
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

# Package pre-reqs

include_recipe "build-essential"
include_recipe "apache2"
include_recipe "nagios::client_source"
include_recipe "php"
include_recipe "php::module_gd"

pkgs = value_for_platform(
    ["redhat","centos","fedora","scientific"] =>
        {"default" => %w{ openssl-devel gd-devel }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ libssl-dev libgd2-xpm-dev }},
    "default" => %w{ libssl-dev libgd2-xpm-dev }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# %w{php gd gd-devel}.each do |pkg|
#   package pkg
# end

group node['nagios']['group'] do
  members [ node['nagios']['user'], node['apache']['user'] ]
  action :modify
end

version = node['nagios']['server']['version']

remote_file "#{Chef::Config[:file_cache_path]}/nagios-#{version}.tar.gz" do
  source "http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-#{version}.tar.gz"
  checksum node['nagios']['server']['checksum']
  action :create_if_missing
end

bash "compile-nagios" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nagios-#{version}.tar.gz
    cd nagios-#{version}
    ./configure --prefix=/usr \
        --mandir=/usr/share/man \
        --bindir=/usr/sbin \
        --sbindir=/usr/lib/cgi-bin/nagios3 \
        --datadir=#{node['nagios']['docroot']} \
        --sysconfdir=#{node['nagios']['conf_dir']} \
        --infodir=/usr/share/info \
        --libexecdir=#{node['nagios']['plugin_dir']} \
        --localstatedir=#{node['nagios']['state_dir']} \
        --enable-event-broker \
        --with-nagios-user=#{node['nagios']['user']} \
        --with-nagios-group=#{node['nagios']['group']} \
        --with-command-user=#{node['nagios']['user']} \
        --with-command-group=#{node['nagios']['group']} \
        --with-init-dir=/etc/init.d \
        --with-lockfile=#{node['nagios']['run_dir']}/nagios3.pid \
        --with-mail=/usr/bin/mail \
        --with-perlcache \
        --with-htmurl=/nagios3 \
        --with-cgiurl=/cgi-bin/nagios3
    make all
    make install
    make install-init
    make install-config
    make install-commandline
    make install-webconf
  EOH
  creates "/usr/sbin/nagios"
end

directory "#{node['nagios']['conf_dir']}/conf.d" do
  owner "root"
  group "root"
  mode "0755"
end

%w{ cache_dir log_dir run_dir }.each do |dir|
  
  directory node['nagios'][dir] do 
    owner node['nagios']['user']
    group node['nagios']['group']
    mode "0755"
  end

end

directory "/usr/lib/nagios3" do
  owner node['nagios']['user']
  group node['nagios']['group']
  mode "0755"
end

link "#{node['nagios']['conf_dir']}/stylesheets" do
  to "#{node['nagios']['docroot']}/stylesheets"
end

apache_module "cgi" do
  enable :true
end

