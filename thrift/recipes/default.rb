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
include_recipe "build-essential"
include_recipe "boost"
include_recipe "java"
include_recipe "subversion"

%w{ flex bison libtool autoconf pkg-config }.each do |pkg|
  package pkg
end

bash "install_thrift" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    svn co http://svn.apache.org/repos/asf/incubator/thrift thrift
    cd thrift/trunk;
    cp /usr/share/aclocal/pkg.m4 ./aclocal
    sh bootstrap.sh
    ./configure --with-boost=/usr/local --with-libevent=/usr/local --prefix=/usr/local
    make install
  EOH
  not_if { FileTest.exists?("/usr/local/bin/thrift") }
end
