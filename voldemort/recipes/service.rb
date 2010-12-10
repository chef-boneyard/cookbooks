#
# Author:: John E. Vincent <lusis.org+github.com@gmail.com>
# Cookbook Name:: voldemort
# Recipe:: service
#
# Copyright 2010, John E. Vincent
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

case node.platform
when "centos", "redhat", "fedora"

  template "log4j.properties" do
    path "#{node[:voldemort][:log4j_dir]}/log4j.properties"
    source "log4j.properties.erb"
    owner "voldemort"
    group "voldemort"
  end

  template "voldemort-server" do
    path "/etc/init.d/voldemort-server"
    source "voldemort-redhat.init.erb"
    owner "root"
    group "root"
    mode "0755"
  end

  service "voldemort-server" do
    action [:enable]
  end
else
  log("Sorry. I don't have support for anything other than RedHat derivatives at this point. I'm working on it...")
end
