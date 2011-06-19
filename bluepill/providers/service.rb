#
# Cookbook Name:: bluepill
# Provider:: service
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

require 'chef/mixin/command'
require 'chef/mixin/language'
include Chef::Mixin::Command

action :enable do
  unless @bp.enabled
    link "#{node['bluepill']['init_dir']}/#{new_resource.service_name}" do
      to node['bluepill']['bin']
      only_if { ::File.exists?("#{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill") }
    end
  end
end

action :load do
  unless @bp.running
    execute "#{node['bluepill']['bin']} load #{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill"
  end
end

action :start do
  unless @bp.running
    execute "#{node['bluepill']['bin']} start #{new_resource.service_name}"
  end
end

action :disable do
  if @bp.enabled
    file "#{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill" do
      action :delete
    end
    link "#{node['bluepill']['init_dir']}/#{new_resource.service_name}" do
      action :delete
    end
  end
end

action :stop do
  if @bp.running
    execute "#{node['bluepill']['bin']} stop #{new_resource.service_name}"
  end
end

action :restart do
  if @bp.running
    execute "#{node['bluepill']['bin']} restart #{new_resource.service_name}"
  end
end

def load_current_resource
  @bp = Chef::Resource::BluepillService.new(new_resource.name)
  @bp.service_name(new_resource.service_name)

  Chef::Log.debug("Checking status of service #{new_resource.service_name}")

  begin
    if run_command_with_systems_locale(:command => "#{node['bluepill']['bin']} status #{new_resource.service_name}") == 0
      @bp.running(true)
    end
  rescue Chef::Exceptions::Exec
    @bp.running(false)
    nil
  end

  if ::File.exists?("#{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill") && ::File.symlink?("#{node['bluepill']['init_dir']}/#{new_resource.service_name}")
    @bp.enabled(true)
  else
    @bp.enabled(false)
  end
end
