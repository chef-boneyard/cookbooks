#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2008-2009, Opscode, Inc.
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

p = package "mysql-devel" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse", "fedora"] => { "default" => "mysql-devel" },
    "debian" => {
      "5.0" => "libmysqlclient15-dev",
      "5.0.1" => "libmysqlclient15-dev",
      "5.0.2" => "libmysqlclient15-dev",
      "5.0.3" => "libmysqlclient15-dev",
      "5.0.4" => "libmysqlclient15-dev",
      "5.0.5" => "libmysqlclient15-dev"
    },
    "ubuntu" => {
      "8.04" => "libmysqlclient15-dev",
      "8.10" => "libmysqlclient15-dev",
      "9.04" => "libmysqlclient15-dev"
    },
    "default" => 'libmysqlclient-dev'
  )
  action :nothing
end

p.run_action(:install)

o = package "mysql-client" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse", "fedora"] => { "default" => "mysql" },
    "default" => "mysql-client"
  )
  action :nothing
end

o.run_action(:install)

case node[:platform]
when "centos","redhat", "suse", "fedora"
  package "ruby-mysql" do
    action :install
  end

else
  r = gem_package "mysql" do
    action :nothing
  end

  r.run_action(:install)
end
