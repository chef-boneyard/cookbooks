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
    "default" => ["jdk-#{node['java']['version']}-ea-linux-#{node['java']['arch']}.rpm"]
  },
  ["debian","ubuntu"] => {
    "default" => ["sun-java6-jdk"]
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

when "centos", "redhat", "fedora"

  pkgs.each do |pkg|
    if node['java'].attribute?('rpm_url')
      remote_file "#{Chef::Config[:file_cache_path]}/#{pkg}" do
        source "#{node['java']['rpm_url']}/#{pkg}"
        checksum node['java']['rpm_checksum']
        mode "0644"
      end
    else
      cookbook_file "#{Chef::Config[:file_cache_path]}/#{pkg}" do
        source pkg
        mode "0644"
        action :create_if_missing
      end
    end
  end

else
  Chef::Log.error("Installation of Sun Java packages not supported on this platform.")
end

execute "update-java-alternatives" do
  command "update-java-alternatives -s java-6-sun"
  returns [0,2]
  action :nothing
  only_if { platform?("ubuntu", "debian") }
end

pkgs.each do |pkg|
  package pkg do
    case node['platform']
    when "ubuntu", "debian"
      response_file "java.seed"
    when "centos", "redhat", "fedora"
      source "#{Chef::Config[:file_cache_path]}/#{pkg}" 
      options "--nogpgcheck" # sun/oracle doesn't sign their RPMs o_O
    end
    action :install
    notifies :run, "execute[update-java-alternatives]"
  end
end
