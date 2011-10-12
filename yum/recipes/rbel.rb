#
# Author:: Bryan Berry (bryan.berry@gmail.com)
# Cookbook Name:: yum
# Recipe:: rbel
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

# If rpm installation from a URL supported 302's, we'd just use that.
# Instead, we get to remote_file then rpm_package.

remote_file "#{Chef::Config[:file_cache_path]}/rbel#{major}-release.noarch.rpm" do
  source "http://rbel.co/rbel#{major}"
  not_if "rpm -qa | grep -qx '^rbel#{major}-release.noarch$'"
end


rpm_package "rbel-release" do
  source "#{Chef::Config[:file_cache_path]}/rbel#{major}-release.noarch.rpm"
end
