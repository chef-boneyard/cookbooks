#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: radiant
# Recipe:: db_bootstrap
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

# THIS RECIPE IS DESTRUCTIVE. Normally when running the db:bootstrap rake
# task in Radiant, it prompts the user:
#
# This task will destroy any data in the database. Are you sure you want to 
# continue? [yn] y
# 
# The yes | below will automatically say yes. Only use this recipe if you
# know what you are doing. Otherwise, run the db:bootstrap manually.
#
# The file resource below for the radiant_config_cache.txt is because when
# the db:bootstrap is run by root in the recipe, the file is not writable
# by the default user that runs the application.

app = data_bag_item("apps", "radiant")

node.set[:radiant][:db_bootstrap] = <<EOS
yes | rake #{node[:radiant][:environment]} db:bootstrap \
ADMIN_NAME=Administrator \
ADMIN_USERNAME=admin \
ADMIN_PASSWORD=radiant \
DATABASE_TEMPLATE=empty.yml
EOS

execute "db_bootstrap" do
  command node[:radiant][:db_bootstrap]
  cwd "#{app['deploy_to']}/current"
  creates "#{app['deploy_to']}/current/tmp/radiant_config_cache.txt"
  ignore_failure true
  notifies :create, "ruby_block[remove_radiant_bootstrap]", :immediately
end

file "#{app['deploy_to']}/current/tmp/radiant_config_cache.txt" do
  owner app['owner']
  group app['group']
end

ruby_block "remove_radiant_bootstrap" do
  block do
    Chef::Log.info("Radiant Database Bootstrap completed, removing the destructive recipe[radiant::db_bootstrap]")
    node.run_list.remove("recipe[radiant::db_bootstrap]") if node.run_list.include?("recipe[radiant::db_bootstrap]")
  end
  action :nothing
end
