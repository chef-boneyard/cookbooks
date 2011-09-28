#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: wix
# Recipe:: default
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

file_name = ::File.basename(node['wix']['url'])

remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
  source node['wix']['url']
  checksum node['wix']['checksum']
  notifies :unzip, "windows_zipfile[wix]", :immediately
end

windows_zipfile "wix" do
  path node['wix']['home']
  source "#{Chef::Config[:file_cache_path]}/#{file_name}"
  action :nothing
end

# update path
windows_path node['wix']['home'] do
 action :add
end