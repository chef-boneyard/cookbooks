#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2011, Bryan W. Berry (bryan.berry@gmail.com) 
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

package "sudo" do
  action :upgrade
end

template "/etc/sudoers" do
  source "sudoers_d.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :sudoers_groups => node['authorization']['sudo']['groups'],
    :sudoers_users => node['authorization']['sudo']['users'],
    :passwordless => node['authorization']['sudo']['passwordless']
  )
end

directory "/etc/sudoers.d" do
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/etc/sudoers.d/README" do
	source "README.sudoers"
	mode 0440
  owner "root"
  group "root"
end

