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

devpkg = package "mysql-devel" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse", "fedora"] => { "default" => "mysql-devel" },
    ["debian", "ubuntu"] => { "default" => 'libmysqlclient-dev' },
    "default" => 'libmysqlclient-dev'
  )
  action :nothing
end

devpkg.run_action(:install)

clntpkg = package "mysql-client" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse", "fedora"] => { "default" => "mysql" },
    "default" => "mysql-client"
  )
  action :nothing
end

clntpkg.run_action(:install)

if platform?(%w{debian ubuntu redhat centos fedora suse})

  rbpkg = package "mysql-ruby" do
    package_name value_for_platform(
      [ "centos", "redhat", "suse", "fedora"] => { "default" => "ruby-mysql" },
      ["debian", "ubuntu"] => { "default" => 'libmysql-ruby' },
      "default" => 'libmysql-ruby'
    )
    action :nothing
  end

  rbpkg.run_action(:install)

else

  rbpkg = gem_package "mysql" do
    action :nothing
  end

  rbpkg.run_action(:install)

end
