#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Recipe:: sun
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

pkgs = value_for_platform(
  ["centos","redhat","fedora"] => {
    "default" => [""]
  },
  ["debian","ubuntu"] => {
    "default" => ["sun-java6-jre","sun-java6-jdk"]
  }
)

case node['platform']
when "ubuntu"
  apt_repository "ubuntu-partner" do
    uri "http://archive.canonical.com/ubuntu"
    distribution node['lsb']['codename']
    components ['partner']
    action :add
  end
  # update-java-alternatives doesn't work with only sun java installed
  node.set['java']['java_home'] = "/usr/lib/jvm/java-6-sun"
when "debian"
  apt_repository "debian-non-free" do
    uri "http://http.us.debian.org/debian"
    distribution "stable"
    components ['main','contrib','non-free']
    action :add
  end
  # update-java-alternatives doesn't work with only sun java installed
  node.set['java']['java_home'] = "/usr/lib/jvm/java-6-sun"
else
  Chef::Log.error("Installation of Sun Java packages not supported on this platform.")
end

execute "update-java-alternatives" do
  command "update-java-alternatives -s java-6-sun"
  returns [0,2]
  action :nothing
  only_if do platform?("ubuntu", "debian") end
end

pkgs.each do |pkg|
  package pkg do
    response_file "java.seed" if platform?("ubuntu", "debian")
    action :install
    notifies :run, "execute[update-java-alternatives]"
  end
end
