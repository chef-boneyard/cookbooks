#
# Cookbook Name:: daemontools
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

def load_current_resource
  @svc = Chef::Resource::DaemontoolsService.new(new_resource.name)
  @svc.service_name(new_resource.service_name)

  Chef::Log.debug("Checking status of service #{new_resource.service_name}")

  begin
    if run_command_with_systems_locale(:command => "svok #{new_resource.directory}") == 0
      @svc.running(true)
    end
  rescue Chef::Exceptions::Exec
    @svc.running(false)
    nil
  end

  if ::File.symlink?("#{node['daemontools']['service_dir']}/#{new_resource.service_name}") && ::File.exists?("#{node['daemontools']['service_dir']}/#{new_resource.service_name}/run")
    @svc.enabled(true)
  else
    @svc.enabled(false)
  end
end

action :enable do
  unless @svc.enabled
    directory new_resource.directory do
      owner new_resource.owner
      group new_resource.group
      mode 0755
    end
    
    if new_resource.template
      template "#{new_resource.directory}/run" do
        source "sv-#{new_resource.template}-run.erb"
        cookbook new_resource.cookbook if new_resource.cookbook
        owner new_resource.owner
        group new_resource.group
        mode 0755
        variables :variables => new_resource.variables unless new_resource.variables.empty?
      end
      if new_resource.log
        directory "#{new_resource.directory}/log" do
          owner new_resource.owner
          group new_resource.group
          mode 0755
        end
        template "#{new_resource.directory}/log/run" do
          source "sv-#{new_resource.template}-log-run.erb"
          cookbook new_resource.cookbook if new_resource.cookbook
          owner new_resource.owner
          group new_resource.group
          mode 0755
        end
      end
      if new_resource.finish
        template "#{new_resource.directory}/finish" do
          source "sv-#{new_resource.template}-finish.erb"
          cookbook new_resource.cookbook if new_resource.cookbook
          owner new_resource.owner
          group new_resource.group
          mode 0755
        end
      end
    end

    unless new_resource.env.empty?
      directory "#{new_resource.directory}/env" do
        owner new_resource.owner
        group new_resource.group
        mode 0755
      end
      new_resource.env.each do |var, value|
        file "#{new_resource.directory}/env/#{var}" do
          content value
          owner new_resource.owner
          group new_resource.group
          mode 0644
        end
      end
    end

    link"#{node['daemontools']['service_dir']}/#{new_resource.service_name}" do
      to new_resource.directory
    end
  end
end

action :start do
  unless @svc.running
    execute "svc -u #{new_resource.service_name}"
  end
end

action :disable do
  if @svc.enabled
    link "#{node['daemontools']['service_dir']}/#{new_resource.service_name}" do
      action :delete
    end
    execute "svc -dx . log" do
      cwd new_resource.directory
    end
  end
end

action :stop do
  if @svc.running
    execute "svc -p #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :restart do
  if @svc.running
    execute "svc -t #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :up do
  if @svc.running
    execute "svc -u #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :once do
  if @svc.running
    execute "svc -o #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :pause do
  if @svc.running
    execute "svc -p #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :cont do
  if @svc.running
    execute "svc -c #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :hup do
  if @svc.running
    execute "svc -h #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :alrm do
  if @svc.running
    execute "svc -a #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :int do
  if @svc.running
    execute "svc -i #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :term do
  if @svc.running
    execute "svc -t #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end

action :kill do
  if @svc.running
    execute "svc -k #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
  end
end
