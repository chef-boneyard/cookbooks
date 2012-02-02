#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: gecode
# Recipe:: source
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

include_recipe 'build-essential'

version = node['gecode']['version']

remote_file "#{Chef::Config[:file_cache_path]}/gecode-#{version}.tar.gz" do
  source "#{node['gecode']['url']}/gecode-#{version}.tar.gz"
  checksum node['gecode']['checksum']
  mode 0644
end

lib_name = value_for_platform("mac_os_x" => { "default" => "libgecodekernel.dylib" }, "default" => "libgecodekernel.so")

bash "build gecode from source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar zxvf gecode-#{version}.tar.gz
  (cd gecode-#{version} && ./configure #{node['gecode']['configure_options'].join(" ")})
  (cd gecode-#{version} && make && make install)
  EOH
  not_if { ::File.exists?("/usr/local/lib/#{lib_name}") }
end

# configure the dynamic linker, redhat only
case node['platform']
when 'centos', 'redhat', 'fedora'
  directory "/etc/ld.so.conf.d/" do
    owner "root"
    group "root"
    mode 0755
  end
  execute "ldconfig" do
    command "ldconfig"
    action :nothing
  end

  file "/etc/ld.so.conf.d/gecode.conf" do
    content "/usr/local/lib "
    notifies :run, "execute[ldconfig]"
  end
end
