#
# Cookbook Name:: application
# Recipe:: tomcat 
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

app = node.run_state[:current_app]

include_recipe "tomcat"

# remove ROOT application
# TODO create a LWRP to enable/disable tomcat apps
directory "#{node['tomcat']['webapp_dir']}/ROOT" do
  recursive true
  action :delete
  not_if "test -L #{node['tomcat']['context_dir']}/ROOT.xml"
end
link "#{node['tomcat']['context_dir']}/ROOT.xml" do
  to "#{app['deploy_to']}/shared/#{app['id']}.xml"
  notifies :restart, resources(:service => "tomcat")
end

if ::File.symlink?(::File.join(node['tomcat']['context_dir'], "ROOT.xml"))
  d = resources(:remote_file => app['id'])
  d.notifies :restart, resources(:service => "tomcat")
end
