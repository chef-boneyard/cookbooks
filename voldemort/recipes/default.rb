#
# Author:: John E. Vincent <lusis.org+github.com@gmail.com>
# Cookbook Name:: voldemort
# Recipe:: default
#
# Copyright 2010, John E. Vincent
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

template "cluster.xml" do
  path "#{node[:voldemort][:config_dir]}/config/cluster.xml"
  source "cluster.xml.erb"
  owner "voldemort"
  group "voldemort"
end

template "server.properties" do
  path "#{node[:voldemort][:config_dir]}/config/server.properties"
  source "server.properties.erb"
  owner "voldemort"
  group "voldemort"
end

template "stores.xml" do
  path "#{node[:voldemort][:config_dir]}/config/stores.xml"
  source "stores.xml.erb"
  owner "voldemort"
  group "voldemort"
end

template "log4j.properties" do
  path "#{node[:voldemort][:install_dir]}/voldemort-#{node[:voldemort][:version]}/src/java/log4j.properties"
  source "log4j.properties.erb"
  owner "voldemort"
  group "voldemort"
end
