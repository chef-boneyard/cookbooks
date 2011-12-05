#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Recipe:: oracle_i386
#
# Copyright 2010-2011, Opscode, Inc.
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

java_home = node['java']["java_home"]
java_root = java_home.split('/')[0..-2].join('/')
  
case node['java']['jdk_version']
when "jdk6"
  tarball_url = node[:java][:jdk]['6'][:i586][:url]
  tarball_checksum = node[:java][:jdk]['6'][:i586][:checksum]
when "jdk7"
  tarball_url = node[:java][:jdk]['7'][:i586][:url]
  tarball_checksum = node[:java][:jdk]['7'][:i586][:checksum]
end

java_cpr "jdk-alt" do
  url tarball_url
  checksum tarball_checksum
  app_root java_root
  default false
  action :install
end
