#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: gunicorn
# Provider:: config
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

action :create do
  
  Chef::Log.info("Creating #{@new_resource} at #{@new_resource.path}")  unless exists?
  
  template_variables = {}
  %w{listen backlog preload_app worker_processes worker_class worker_timeout worker_keepalive worker_max_requests server_hooks pid}.each do |a|
    template_variables[a.to_sym] = new_resource.send(a)
  end
  
  Chef::Log.debug("Using variables #{template_variables} to configure #{@new_resource}")
  
  config_dir = ::File.dirname(new_resource.path)
  
  d = directory config_dir do
    recursive true
    action :create
  end
  
  t = template new_resource.path do
    source new_resource.template
    cookbook new_resource.cookbook
    mode "0644"
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
    variables template_variables
  end
  
  new_resource.updated_by_last_action(d.updated_by_last_action? || t.updated_by_last_action?)
end

action :delete do 
  if exists?
    if ::File.writable?(@new_resource.path)
      Chef::Log.info("Deleting #{@new_resource} at #{@new_resource.path}")
      ::File.delete(@new_resource.path)
      new_resource.updated_by_last_action(true)
    else
      raise "Cannot delete #{@new_resource} at #{@new_resource.path}!"
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::GunicornConfig.new(@new_resource.name)
  @current_resource.path(@new_resource.path)
  @current_resource
end

private
  def exists?
    ::File.exist?(@current_resource.path)
  end
