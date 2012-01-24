# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Recipe:: openjdk
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

version = node['java']['jdk_version']
java_home = node['java']['java_home']
java_home_parent = File.dirname java_home
jdk_home = ""

pkgs = value_for_platform(
                          ["centos","redhat","fedora"] => {
                            "default" => ["java-1.#{version}.0-openjdk","java-1.#{version}.0-openjdk-devel"]
                          },
                          "default" => ["openjdk-#{version}-jdk"]
                          )

# done by special request for rberger
ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
end

ruby_block "update-java-alternatives" do
  block do
    require "fileutils"
    arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"
    Chef::Log.debug("glob is #{java_home_parent}/java*#{version}*openjdk*")
    jdk_home = Dir.glob("#{java_home_parent}/java*#{version}*openjdk?{,#{arch}}")[0]
    Chef::Log.debug("jdk_home is #{jdk_home}")
    # delete the symlink if it already exists
    if File.exists? java_home
      FileUtils.rm_f java_home
    end
    FileUtils.ln_sf jdk_home, java_home
    
    if platform?("ubuntu", "debian") and version == 6
      # specific to Ubuntu, this finds the file which specifies all
      # the symlinks to be updated
      java_link_name = Dir.glob("#{java_home_parent}/.java*#{version}*openjdk.jinfo")[0]
      java_link_name = File.basename(java_link_name).split('.')[1..-2].join('.')
      cmd = Chef::ShellOut.new(
                               "update-java-alternatives -s #{java_link_name}"
                               ).run_command
      unless cmd.exitstatus == 0 or  cmd.exitstatus == 2
        Chef::Application.fatal!("Failed to update-alternatives for openjdk!")
      end
    else
      cmd = Chef::ShellOut.new(
         %Q[ update-alternatives --install /usr/bin/java java #{java_home}/bin/java 1;
             update-alternatives --set java #{java_home}/bin/java  ]
                             ).run_command
      unless cmd.exitstatus == 0 or  cmd.exitstatus == 2
        Chef::Application.fatal!("Failed to update-alternatives for openjdk!")
      end
    end
  end
  action :nothing
end
  
pkgs.each do |pkg|
  package pkg do
    action :install
    notifies :create, "ruby_block[update-java-alternatives]"
  end
end
