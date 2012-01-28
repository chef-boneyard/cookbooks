#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2008-2011, Opscode, Inc.
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

# Include Opscode helper in Recipe class to get access
# to debian_before_squeeze? and ubuntu_before_lucid?
::Chef::Recipe.send(:include, Opscode::Mysql::Helpers)

mysql_packages = case node['platform']
when "centos", "redhat", "suse", "fedora", "scientific", "amazon"
  %w{mysql mysql-devel}
when "ubuntu","debian"
  if debian_before_squeeze? || ubuntu_before_lucid?
    %w{mysql-client libmysqlclient15-dev}
  else
    %w{mysql-client libmysqlclient-dev}
  end
when "freebsd"
  %w{mysql55-client}
else
  %w{mysql-client libmysqlclient-dev}
end

mysql_packages.each do |mysql_pack|
  package mysql_pack do
    action :install
  end
end

if platform?(%w{ redhat centos fedora suse scientific amazon })
  package 'ruby-mysql'
elsif platform?(%w{ debian ubuntu })
  package "libmysql-ruby"
else
  gem_package "mysql" do
    action :install
  end
end
