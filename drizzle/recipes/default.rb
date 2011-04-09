#
# Cookbook Name:: drizzle
# Recipe:: default
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

case node[:platform]
when "ubuntu"
  package "python-software-properties" do
    action :install
  end

  # add drizzle PPA
  execute "apt-add-repository ppa:drizzle-developers/ppa" do
    command "apt-add-repository ppa:drizzle-developers/ppa"
  end

  execute "apt-get update" do
    command "apt-get update"
  end

  package "drizzle" do
    action :install
  end
when "centos","redhat","fedora"
  execute "yum clean all" do
    action :nothing
  end

  template "/etc/yum.repos.d/drizzle.repo" do
    mode "0644"
    source "drizzle.repo.erb"
    notifies :run, resources(:execute => "yum clean all"), :immediately
  end

  package "drizzle7" do
    action :install
  end

end

service "drizzle" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "drizzled"}, "default" => "drizzle")
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart drizzle"
    stop_command "stop drizzle"
    start_command "start drizzle"
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

