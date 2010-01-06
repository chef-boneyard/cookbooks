#
# Cookbook Name:: dynomite
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
include_recipe "ruby"
include_recipe "git"
include_recipe "erlang"

gem_package "rake"
gem_package "open4"

bash "install_dynomite" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  git clone git://github.com/cliffmoon/dynomite.git
  cd dynomite
  git submodule init
  git submodule update
  rake clean
  rake build_tarball
  (cd /usr/local && tar zxf /tmp/dynomite/build/dynomite.tar.tgz)
  EOH
  not_if { FileTest.exists?("/usr/local/dynomite/bin/dynomite") }
end

gem_package "dynomite" do
  source "http://gems.opscode.com"
end

directory node[:dynomite][:data_dir] do
  recursive true
  owner "root"
  group "root"
  mode "0644"
end
  
directory "/var/log/dynomite" do
  owner "root"
  group "root"
  mode "0644"
end

runit_service "dynomite"
