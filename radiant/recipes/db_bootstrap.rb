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

app = node.run_state[:current_app]

node.set[:radiant][:db_bootstrap] = <<EOS
yes | rake #{node[:app_environment]} db:bootstrap \
ADMIN_NAME=Administrator \
ADMIN_USERNAME=admin \
ADMIN_PASSWORD=radiant \
DATABASE_TEMPLATE=empty.yml
EOS

execute "db_bootstrap" do
  command node[:radiant][:db_bootstrap]
  cwd "#{app['deploy_to']}/current"
  ignore_failure true
end
