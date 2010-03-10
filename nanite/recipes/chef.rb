#
# Author:: Daniel DeLeo <dan@kallistec.com>
#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Daniel DeLeo
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

include_recipe "rabbitmq"

# NOTICE: CHEF REQUIRES A DIFFERENT RABBITMQ ACL CONFIG THAN MOST NANITE
# SETUPS. SEE CHEF-666 (NO JOKE) FOR MORE DETAILS
Chef::Log.info("Configuring nanite *SPECIFICALLY FOR CHEF*. See CHEF-666 for more info")

execute "rabbitmqctl add_vhost /nanite" do
  not_if "rabbitmqctl list_vhosts| grep /nanite"
end

# create 'mapper' and 'nanite' users, give them each the password 'testing'
%w[mapper nanite].each do |agent|
  execute "rabbitmqctl add_user #{agent} testing" do
    not_if "rabbitmqctl list_users |grep #{agent}"
  end
end

# grant the mapper user the ability to do anything with the /nanite vhost
# the three regex's map to config, write, read permissions respectively
execute 'rabbitmqctl set_permissions -p /nanite mapper ".*" ".*" ".*"' do
  not_if 'rabbitmqctl list_user_permissions mapper|grep /nanite'
end

# should set permissions more restrictive for the nanite user, but can't
# because of limitation in chef.
execute 'rabbitmqctl set_permissions -p /nanite nanite ".*" ".*" ".*"' do
  not_if 'rabbitmqctl list_user_permissions nanite|grep /nanite'
end
