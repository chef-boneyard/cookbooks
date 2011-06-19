#
# Cookbook Name:: thrift
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

version = node['thrift']['version']

include_recipe "build-essential"
include_recipe "boost"
include_recipe "python"

%w{ flex bison libtool autoconf pkg-config }.each do |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/thrift-0.6.0.tar.gz" do
  source "#{node['thrift']['mirror']}/thrift/#{version}/thrift-#{version}.tar.gz"
  checksum node['thrift']['checksum']
end

bash "install_thrift" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    (tar -zxvf thrift-#{version}.tar.gz)
    (cd thrift-#{version} && ./configure #{node['thrift']['configure_options'].join(' ')})
    (cd thrift-#{version} && make install)
  EOH
  not_if { FileTest.exists?("/usr/local/bin/thrift") }
end
