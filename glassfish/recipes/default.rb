#
# Cookbook Name:: glassfish
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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


group node[:glassfish][:systemgroup] do
end

user node[:glassfish][:systemuser] do
  comment "SUN Glassfish"
  gid node[:glassfish][:systemgroup]
  home node[:glassfish][:INSTALL_HOME]
  shell "/bin/sh"
end

remote_file "/tmp/glassfish.sh" do
  owner node[:glassfish][:systemuser]
  source node[:glassfish][:fetch_url]
  mode "0744"
  checksum "6d4a20f14de"
end

answer_file = "/tmp/v3-prelude-answer"

template answer_file do
  owner node[:glassfish][:systemuser]
  source "answer_file.erb"
end

directory node[:glassfish][:INSTALL_HOME] do
  owner node[:glassfish][:systemuser]
  group node[:glassfish][:systemgroup]
  mode "0755"
  action :create
  recursive true
end

execute "install-glassfish" do
  command "/tmp/glassfish.sh -a #{answer_file} -s"
  creates File.join(node[:glassfish][:INSTALL_HOME],"uninstall.sh")
  user node[:glassfish][:systemuser]
  action :run
end

file answer_file do
  action :delete
end

template "/etc/init.d/glassfish" do
  source "glassfish-init.d-script.erb"
  mode "0755"
end

service "glassfish" do
  supports :start => true, :restart => true, :stop => true
  action [ :enable, :start ]
end

