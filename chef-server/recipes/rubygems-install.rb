#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
#
# Cookbook Name:: chef
# Recipe:: bootstrap_server
#
# Copyright 2009-2010, Opscode, Inc.
# Copyright 2009, 37signals
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

user "chef" do
  system true
  shell "/bin/sh"
  home node['chef_server']['path']
end

case node['platform']
when "ubuntu"

  if node['platform_version'].to_f >= 9.10
    include_recipe "couchdb"
  elsif node['platform_version'].to_f >= 8.10
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "chef-server::rabbitmq"
  include_recipe "gecode"

when "debian"
  if node['platform_version'].to_f >= 6.0 || node['platform_version'] =~ /.*sid/
    include_recipe "couchdb"
  else
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "chef-server::rabbitmq"
  include_recipe "gecode"

when "centos","redhat","fedora"

  include_recipe "couchdb"
  include_recipe "java"
  include_recipe "chef-server::rabbitmq"
  include_recipe "gecode"

else

  log("Unknown platform for CouchDB. Manual installation of CouchDB required.")
  log("Unknown platform for RabbitMQ. Manual installation of RabbitMQ required.")
  log("Unknown platform for Java. Manual installation of Java required.")
  log("Unknown platform for gecode. Manual installation of gecode required.")
  log("Components that rely on these packages being installed may fail to start.")

end

include_recipe "zlib"
include_recipe "xml"

server_gems = %w{ chef-server-api chef-solr chef-expander }
server_services = %w{ chef-solr chef-expander chef-server }

if node['chef_server']['webui_enabled']
  server_gems << "chef-server-webui"
  server_services << "chef-server-webui"
end

server_gems.each do |gem|
  gem_package gem do
    version node['chef_packages']['chef']['version']
  end
end

chef_dirs = [
  node['chef_server']['log_dir'],
  node['chef_server']['path'],
  node['chef_server']['cache_path'],
  node['chef_server']['backup_path'],
  node['chef_server']['run_path'],
  "/etc/chef"
]

chef_dirs.each do |dir|
  directory dir do
    owner "chef"
    group root_group
    mode 0755
  end
end

%w{ server solr }.each do |cfg|
  template "/etc/chef/#{cfg}.rb" do
    source "#{cfg}.rb.erb"
    owner "chef"
    group root_group
    mode 0600
  end

  link "/etc/chef/webui.rb" do
    to "/etc/chef/server.rb"
  end

  link "/etc/chef/expander.rb" do
    to "/etc/chef/solr.rb"
  end
end

directory node['chef_server']['path'] do
  owner "chef"
  group root_group
  mode 0755
end

%w{ cache search_index }.each do |dir|
  directory "#{node['chef_server']['path']}/#{dir}" do
    owner "chef"
    group root_group
    mode 0755
  end
end

directory "/etc/chef/certificates" do
  owner "chef"
  group root_group
  mode 0700
end

directory node['chef_server']['run_path'] do
  owner "chef"
  group root_group
  mode 0755
end

# install solr
execute "chef-solr-installer" do
  command  "chef-solr-installer -c /etc/chef/solr.rb -u chef -g #{root_group}"
  path %w{ /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin }
  not_if { ::File.exists?("#{node['chef_server']['path']}/solr/home") }
end

case node['chef_server']['init_style']
when "runit"

  include_recipe "runit"

  server_services.each do |svc|
    runit_service svc
  end

  service "chef-server" do
    restart_command "sv int chef-server"
  end

  if node['chef_server']['webui_enabled']
    service "chef-server-webui" do
      restart_command "sv int chef-server-webui"
    end
  end

when "init"

  directory node['chef_server']['run_path'] do
    action :create
    owner "chef"
    group root_group
    mode 0755
  end

  dist_dir = value_for_platform(
    ["ubuntu", "debian"] => { "default" => "debian" },
    ["redhat", "centos", "fedora"] => { "default" => "redhat"}
  )

  conf_dir = value_for_platform(
    ["ubuntu", "debian"] => { "default" => "default" },
    ["redhat", "centos", "fedora"] => { "default" => "sysconfig"}
  )

  chef_version = node['chef_packages']['chef']['version']
  gems_dir = node['languages']['ruby']['gems_dir']

  server_services.each do |svc|
    init_content = IO.read("#{gems_dir}/gems/chef-#{chef_version}/distro/#{dist_dir}/etc/init.d/#{svc}")
    conf_content = IO.read("#{gems_dir}/gems/chef-#{chef_version}/distro/#{dist_dir}/etc/#{conf_dir}/#{svc}")

    file "/etc/init.d/#{svc}" do
      content init_content
      mode 0755
    end

    file "/etc/#{conf_dir}/#{svc}" do
      content conf_content
      mode 0644
    end

    link "/usr/sbin/#{svc}" do
      to "#{node['languages']['ruby']['bin_dir']}/#{svc}"
    end

    service "#{svc}" do
      supports :status => true
      action [ :enable, :start ]
    end
  end

when "upstart"

  log "This recipe does not yet support configuring services with Upstart."

when "bluepill"

  include_recipe "bluepill"

  server_services.each do |svc|
    template "#{node['bluepill']['conf_dir']}/#{svc}.pill" do
      source "#{svc}.pill.erb"
      mode 0644
    end

    bluepill_service svc do
      action [:enable,:load,:start]
    end
  end

when "daemontools"

  include_recipe "daemontools"

  server_services.each do |svc|
    daemontools_service svc do
      template svc
      log true
      action [:enable, :start]
    end
  end

when "bsd"

  log("You specified service style 'bsd'. You will need to set up your rc.local file for chef-expander, chef-solr and chef-server.")
  log("chef-expander startup command: chef-expander -d -n #{node['chef_server']['expander_nodes']}")
  log("chef-solr startup command: chef-solr -d")
  log("chef-server startup command: chef-server -d -N -p #{node['chef_server']['api_port']} -e production -P #{node['chef_server']['run_path']}/server.%s.pid")

else

  log("Could not determine service init style, manual intervention required to set up server services.")

end
