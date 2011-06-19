#
# Cookbook Name:: snort
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

case node['platform']
when 'ubuntu', 'debian'

  snort_package = case node['snort']['database']
                  when "none"
                    "snort"
                  when "mysql"
                    "snort-mysql"
                  when "postgresql","pgsql","postgres"
                    "snort-pgsql"
                  end

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  template "/var/cache/local/preseeding/snort.seed" do
    source "snort.seed.erb"
    owner "root"
    group "root"
    mode 0755
    notifies :run, "execute[preseed snort]", :immediately
  end

  execute "preseed snort" do
    command "debconf-set-selections /var/cache/local/preseeding/snort.seed"
    action :nothing
  end

  package snort_package do
    action :upgrade
  end

  package "snort-rules-default" do
    action :upgrade
  end

when "redhat", "centos", "fedora"

  snort_package = case node['snort']['database']
                  when "none"
                    "snort"
                  when "mysql"
                    "snort-mysql"
                  when "postgresql","pgsql","postgres"
                    "snort-postgresql"
                  end

  snort_rpm = "#{snort_package}-#{node['snort']['rpm']['version']}.i386.rpm"

  remote_file "#{Chef::Config[:file_cache_path]}/#{snort_rpm}" do
    source "http://www.snort.org/dl/snort-current/#{snort_rpm}"
    checksum node['snort']['rpm']["checksum_#{snort_package}"]
    mode 0644
  end

  rpm_package "#{Chef::Config[:file_cache_path]}/#{snort_rpm}" do
    action :install
  end
end
