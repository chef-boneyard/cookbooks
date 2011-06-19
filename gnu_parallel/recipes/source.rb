#
# Cookbook Name:: gnu_parallel
# Recipe:: source
#
# Copyright 2011, Opscode, Inc.
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

version = node['gnu_parallel']['version']

remote_file "#{Chef::Config[:file_cache_path]}/parallel-#{version}.tar.bz2" do
  source "#{node['gnu_parallel']['url']}/parallel-#{version}.tar.bz2"
  checksum node['gnu_parallel']['checksum']
  mode 0644
end

bash "build gnu parallel" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -jxvf parallel-#{version}.tar.bz2
  (cd parallel-#{version} && ./configure #{node['gnu_parallel']['configure_options'].join(" ")})
  (cd parallel-#{version} && make && make install)
  EOF
  not_if "parallel --version | grep -x 'GNU parallel #{version}'"
end
