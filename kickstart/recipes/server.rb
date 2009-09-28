#
# Cookbook Name:: kickstart
# Recipe:: server
#
# Copyright 2009, Opscode, Inc.
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
include_recipe "apache2"

directory "/srv/kickstart" do
  owner "root"
  group "root"
  mode "0755"
end

template "/srv/kickstart/ks.cfg" do
  source "ks.cfg.erb"
  mode "0644"
  owner "root"
  group "root"
end

link "/srv/kickstart/index.html" do
  to "/srv/kickstart/ks.cfg"
end

template "#{node[:apache][:dir]}/sites-available/kickstart.conf" do
  source "kickstart.conf.erb"
  variables(
    :virtual_host_name => node[:kickstart][:virtual_host_name],
    :docroot => "/srv/kickstart"
  )
  mode "0644"
  owner "root"
  group "root"
end

apache_site "kickstart.conf" do
  enable true
end

