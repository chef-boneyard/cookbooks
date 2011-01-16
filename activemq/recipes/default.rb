#
# Cookbook Name:: activemq
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

include_recipe "java"
include_recipe "runit"

version = node[:activemq][:version]
mirror = node[:activemq][:mirror]

unless ::File.exists?("/opt/apache-activemq-#{version}/bin/activemq")
  remote_file "/tmp/apache-activemq-#{version}-bin.tar.gz" do
    source "#{mirror}/apache/activemq/apache-activemq/#{version}/apache-activemq-#{version}-bin.tar.gz"
    mode "0644"
  end

  execute "tar zxf /tmp/apache-activemq-#{version}-bin.tar.gz" do
    cwd "/opt"
  end
end

file "/opt/apache-activemq-#{version}/bin/activemq" do
  owner "root"
  group "root"
  mode "0755"
end

runit_service "activemq"
