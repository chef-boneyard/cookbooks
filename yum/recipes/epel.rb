#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: yum
# Recipe:: epel
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

major = node['platform_version'].to_i
epel  = node['yum']['epel_release']

# If rpm installation from a URL supported 302's, we'd just use that.
# Instead, we get to remote_file then rpm_package.

remote_file "#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm" do
  source "http://download.fedoraproject.org/pub/epel/#{major}/i386/epel-release-#{epel}.noarch.rpm"
  not_if "rpm -qa | grep -qx '^epel-release-#{epel}.noarch$'"
end


rpm_package "epel-release" do
  source "#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm"
end
