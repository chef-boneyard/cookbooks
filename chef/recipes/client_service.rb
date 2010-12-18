#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef
# Recipe:: bootstrap_client
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

directory node["chef"]["log_dir"] do
  recursive true
  owner "root"
  group root_group
  mode 0755
end

case node[:chef][:init_style]
when "runit"

  include_recipe "runit"
  runit_service "chef-client"

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

  chef_version = node.chef_packages.chef[:version]

  init_content = IO.read("#{node[:languages][:ruby][:gems_dir]}/gems/chef-#{chef_version}/distro/#{dist_dir}/etc/init.d/chef-client")
  conf_content = IO.read("#{node[:languages][:ruby][:gems_dir]}/gems/chef-#{chef_version}/distro/#{dist_dir}/etc/#{conf_dir}/chef-client")

  file "/etc/init.d/chef-client" do
    content init_content
    mode 0755
  end

  file "/etc/#{conf_dir}/chef-client" do
    content conf_content
    mode 0644
  end

  service "chef-client" do
    action :enable
  end

when "bluepill"

  include_recipe "bluepill"

  template "#{node[:bluepill][:conf_dir]}/chef-client.pill" do
    source "chef-client.pill.erb"
    mode 0644
  end

  bluepill_service "chef-client" do
    action [:enable,:load,:start]
  end

when "daemontools"

  include_recipe "daemontools"

  daemontools_service "chef-client" do
    directory "/etc/sv/chef-client"
    template "chef-client"
    action [:enable,:start]
    log true
  end

when "bsd"
  log("You specified service style 'bsd'. You will need to set up your rc.local file.")
  log("Hint: chef-client -i #{node[:chef][:client_interval]} -s #{node[:chef][:client_splay]}")
else
  log("Could not determine service init style, manual intervention required to start up the chef-client service.")
end
