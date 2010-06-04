#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: riak
# Recipe:: inno
#
# Copyright (c) 2010 Basho Technologies, Inc.
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

include_recipe "riak"

inno_version = "10"
base_uri = "http://downloads.basho.com/innostore/innostore-#{inno_version}/"
base_filename = "innostore-#{inno_version}"

package_file =  case node[:riak][:package][:type]
                when "binary"
                  case node[:platform]
                  when "debian","ubuntu"
                    machines = {"x86_64" => "amd64", "i386" => "i386"} 
                    "#{base_filename.gsub(/\-/, '_')}-1_#{machines[node[:kernel][:machine]]}.deb"
                  when "centos","redhat","fedora","suse"
                    "#{base_filename}-1.#{node[:kernel][:machine]}.rpm"
                  # when "mac_os_x"
                  #  "#{base_filename}.osx.#{node[:kernel][:machine]}.tar.gz"
                  end
                when "source"
                  "#{base_filename}.tar.gz"
                end

remote_file "/tmp/riak_pkg/#{package_file}" do
  source base_uri + package_file
  owner "root"
  mode "0644"
end

case node[:riak][:package][:type]
when "binary"
  package "riak-inno-backend" do
    source "/tmp/riak_pkg/#{package_file}"
    action :install
    provider value_for_platform(
      [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
      [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
    )
  end
when "source"
  execute "riak-inno-src-unpack" do
    cwd "/tmp/riak_pkg"    
    command "tar xvfz #{package_file}"
  end
  
  execute "riak-inno-src-build" do
    cwd "/tmp/riak_pkg/#{base_filename}"
    command "make"
  end
  
  execute "riak-inno-src-install" do
    cwd "/tmp/riak_pkg/#{base_filename}"
    command "./rebar install target=#{node[:riak][:package][:prefix]}/riak/lib"
    not_if "test -d #{node[:riak][:package][:prefix]}/riak/lib/#{base_filename}"
  end
end

