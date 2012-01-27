#
# Author:: Alice Kaerast (<alice.kaerast@webanywhere.co.uk>)
# Cookbook Name:: yum
# Recipe:: percona
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

architecture = node['kernel']['machine']

remote_file "#{Chef::Config[:file_cache_path]}/percona-release-0.0.1.#{architecture}.rpm" do
  source "http://www.percona.com/downloads/percona-release/percona-release-0.0-1.#{architecture}.rpm"
  not_if "rpm -qa | grep -q '^percona-release'"
  notifies :install, "rpm_package[percona-release]", :immediately
end

rpm_package "percona-release" do
  source "#{Chef::Config[:file_cache_path]}/percona-release-0.0.1.#{architecture}.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/percona-release-0.0.1.#{architecture}.rpm")}
  action :nothing
end

file "ius-release-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/percona-release-0.0.1.#{architecture}.rpm"
  action :delete
end
