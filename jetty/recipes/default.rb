#
# Cookbook Name:: jetty
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

case node.platform
when "centos","redhat","fedora"
  include_recipe "jpackage"
end

jetty_pkgs = value_for_platform(
  ["debian","ubuntu"] => {
    "default" => ["jetty","libjetty-extra"]
  },
  ["centos","redhat","fedora"] => {
    "default" => ["jetty6","jetty6-jsp-2.1","jetty6-management"]
  },
  "default" => ["jetty"]
)
jetty_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "jetty" do
  case node["platform"]
  when "centos","redhat","fedora"
    service_name "jetty6"
    supports :restart => true
  when "debian","ubuntu"
    service_name "jetty"
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end

template "/etc/default/jetty" do
  source "default_jetty.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "jetty")
end
