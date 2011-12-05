#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Recipe:: oracle
#
# Copyright 2011, Bryan w. Berry
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
  
arch = node[:kernel][:machine] == 'x86_64' ? 'x86_64' : 'i586'

jdk_version = node['java']['jdk_version']

#convert version number to a string if it isn't already
if jdk_version.instance_of? Fixnum
  jdk_version = jdk_version.to_s
end

case jdk_version
when "6"
  tarball_url = node[:java][:jdk]['6'][arch][:url]
  tarball_checksum = node[:java][:jdk]['6'][arch][:checksum]
when "7"
  tarball_url = node[:java][:jdk]['7'][arch][:url]
  tarball_checksum = node[:java][:jdk]['7'][arch][:checksum]
end

puts "the arch is #{arch}"
puts "here is the tarball url #{tarball_url} "

java_cpr "jdk" do
  url tarball_url
  checksum tarball_checksum
  app_root java_root
  bin_cmds ["java"]
  action :install
end

