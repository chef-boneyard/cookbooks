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

package "rabbitmq-server"

service "rabbitmq-server" do
  if platform?("centos","redhat","fedora")
    start_command "/sbin/service rabbitmq-server start &> /dev/null"
    stop_command "/sbin/service rabbitmq-server stop &> /dev/null"
  end
  supports [ :restart, :status ]
  action [ :enable, :start ]
end

# add a chef vhost to the queue
execute "rabbitmqctl add_vhost /chef" do
  not_if "rabbitmqctl list_vhosts| grep /chef"
end

# create chef user for the queue
execute "rabbitmqctl add_user chef testing" do
  not_if "rabbitmqctl list_users |grep chef"
end

# grant the mapper user the ability to do anything with the /chef vhost
# the three regex's map to config, write, read permissions respectively
execute 'rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"' do
  not_if 'rabbitmqctl list_user_permissions mapper|grep /chef'
end
