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
  ["arch","freebsd"] => {
    "default" => ["openjdk#{version}"]
  },
  "default" => ["openjdk-#{version}-jdk"]
  )

# done by special request for rberger
ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
end

if platform?("ubuntu","debian","redhat","centos","fedora","scientific","amazon")
  ruby_block "update-java-alternatives" do
    block do
      if platform?("ubuntu", "debian") and version == 6
        run_context = Chef::RunContext.new(node, {})
        r = Chef::Resource::Execute.new("update-java-alternatives", run_context)
        r.command "update-java-alternatives -s java-6-openjdk"
        r.returns [0,2]
        r.run_action(:create)
      else
        # have to do this on ubuntu for version 7 because Ubuntu does
        # not currently set jdk 7 as the default jvm on installation
        require "fileutils"
        arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"
        Chef::Log.debug("glob is #{java_home_parent}/java*#{version}*openjdk*")
        jdk_home = Dir.glob("#{java_home_parent}/java*#{version}*openjdk{,[-\.]#{arch}}")[0]
        Chef::Log.debug("jdk_home is #{jdk_home}")
        # delete the symlink if it already exists
        if File.exists? java_home
          FileUtils.rm_f java_home
        end
        FileUtils.ln_sf jdk_home, java_home

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
end

pkgs.each do |pkg|
  package pkg do
    action :install
    notifies :create, "ruby_block[update-java-alternatives]"  if platform?("ubuntu","debian","redhat","centos","fedora","scientific","amazon")
  end
end
