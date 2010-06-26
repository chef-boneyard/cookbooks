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

include_recipe "chef::bootstrap_client"

case node[:platform]
when "ubuntu"
  if node[:platform_version].to_f >= 9.10
    include_recipe "couchdb"
  elsif node[:platform_version].to_f >= 8.10
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "rabbitmq_chef"
when "debian"
  if node[:platform_version] =~ /.*sid/
    include_recipe "couchdb"
  else
    include_recipe "couchdb::source"
  end

  include_recipe "java"
  include_recipe "rabbitmq_chef"
when "centos","redhat","fedora"
  include_recipe "java"
  include_recipe "couchdb"
  include_recipe "rabbitmq_chef"
else
  log("Unknown platform for CouchDB. Manual installation of CouchDB required.")
  log("Unknown platform for RabbitMQ. Manual installation of RabbitMQ required.")
  log("Unknown platform for Java. Manual installation of Java required.")
  log("Components that rely on these packages being installed may fail to start.")
end

include_recipe "zlib"
include_recipe "xml"

server_gems = %w{ chef-server-api chef-solr }
server_services = %w{ chef-server chef-solr chef-solr-indexer }

if node.chef.attribute?("webui_enabled")
  server_gems << "chef-server-webui"
  server_services << "chef-server-webui"
end

server_gems.each do |gem|
  gem_package gem do
    version node.chef.server_version
  end
end

%w{ server solr }.each do |cfg|
  template "/etc/chef/#{cfg}.rb" do
    source "#{cfg}.rb.erb"
    owner "root"
    group root_group
    mode "600"
  end
end

%w{ cache search_index }.each do |dir|
  directory "#{node[:chef][:path]}/#{dir}" do
    owner "root"
    group root_group
    mode "755"
  end
end

directory "/etc/chef/certificates" do
  owner "root"
  group root_group
  mode "700"
end

directory node[:chef][:run_path] do
  owner "root"
  group root_group
  mode "755"
end

case node[:chef][:init_style]
when "runit"

  include_recipe "runit"

  server_services.each do |svc|
    runit_service svc
  end

  service "chef-server" do
    restart_command "sv int chef-server"
  end

  if node.chef.attribute?("webui_enabled")
    service "chef-server-webui" do
      restart_command "sv int chef-server-webui"
    end
  end

when "init"

  directory node[:chef][:run_path] do
    action :create
    owner "root"
    group root_group
    mode "755"
  end

  dist_dir = value_for_platform(
    ["ubuntu", "debian"] => { "default" => "debian" },
    ["redhat", "centos", "fedora"] => { "default" => "redhat"}
  )

  conf_dir = value_for_platform(
    ["ubuntu", "debian"] => { "default" => "default" },
    ["redhat", "centos", "fedora"] => { "default" => "sysconfig"}
  )

  chef_version = node.chef.server_version
  gems_dir = node.languages.ruby.gems_dir

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

    service "#{svc}" do
      action [ :enable, :start ]
    end
  end

when "bsd"

  log("You specified service style 'bsd'. You will need to set up your rc.local file for chef-solr-indexer, chef-solr and chef-server.")
  log("Server startup command: chef-server -d")

else

  log("Could not determine service init style, manual intervention required to set up indexer and server services.")

end
