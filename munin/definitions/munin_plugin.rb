#
# Cookbook Name:: munin
# Definition:: munin_plugin
#
# Copyright 2010, OpsCode, Inc.
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


define :munin_plugin, :create_file => false, :enable => true do

  include_recipe "munin::client"

  plugin = params[:plugin] ? params[:plugin] : params[:name]
  plugin_config = params[:plugin_config] ? params[:plugin_config] : node['munin']['plugins']
  plugin_dir = params[:plugin_dir] ? params[:plugin_dir] : node['munin']['plugin_dir']

  if params[:create_file]
    cookbook_file "#{plugin_dir}/#{params[:name]}" do
      cookbook "munin"
      source "plugins/#{params[:name]}"
      owner "root"
      group node['munin']['root']['group']
      mode 0755
    end
  end

  link "#{plugin_config}/#{plugin}" do
    to "#{plugin_dir}/#{params[:name]}"
    if params[:enable]
      action :create
    else
      action :delete
    end
    notifies :restart, resources(:service => "munin-node")
  end

end
