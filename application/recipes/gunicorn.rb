#
# Cookbook Name:: application
# Recipe:: gunicorn 
#
# Copyright 2011, Opscode, Inc.
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

ve = resources(:python_virtualenv => app['id'])
node.default[:gunicorn][:virtualenv] = ve.path

include_recipe "gunicorn"

node.default[:gunicorn][:worker_timeout] = 60
node.default[:gunicorn][:preload_app] = false
node.default[:gunicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
node.default[:gunicorn][:server_hooks] = {:pre_fork => 'import time;time.sleep(1)'}
node.default[:gunicorn][:port] = '8080'

gunicorn_config "/etc/gunicorn/#{app['id']}.py" do
  listen "#{node[:ipaddress]}:#{node[:gunicorn][:port]}"
  worker_timeout node[:gunicorn][:worker_timeout] 
  preload_app node[:gunicorn][:preload_app] 
  worker_processes node[:gunicorn][:worker_processes]
  server_hooks node[:gunicorn][:server_hooks]
  action :create
end
 
runit_service app['id'] do
  template_name 'gunicorn'
  cookbook 'application'
  options('app' => app, 'virtualenv' => ve.path)
  run_restart false
end

if ::File.exists?(::File.join(app['deploy_to'], "current"))
  d = resources(:deploy => app['id'])
  d.restart_command do
    execute "/etc/init.d/#{app['id']} hup"
  end
end

