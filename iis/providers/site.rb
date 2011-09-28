#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: iis
# Provider:: site
#
# Copyright:: 2011, Opscode, Inc.
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

require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut
include Windows::Helper

action :add do
  unless @current_resource.exists
    cmd = "#{appcmd} add site /name:\"#{@new_resource.site_name}\""
    cmd << " /id:#{@new_resource.site_id}" if @new_resource.site_id
    cmd << " /physicalPath:\"#{win_friendly_path(@new_resource.path)}\"" if @new_resource.path
    cmd << " /bindings:#{@new_resource.protocol}/*"
    cmd << ":#{@new_resource.port}:" if @new_resource.port
    cmd << "#{@new_resource.host_header}" if @new_resource.host_header
    shell_out!(cmd)
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} added new site '#{@new_resource.site_name}'")
  else
    Chef::Log.debug("#{@new_resource} site already exists - nothing to do")
  end
end

action :delete do
  if @current_resource.exists
    shell_out!("#{appcmd} delete site /site.name:\"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} deleted")
  else
    Chef::Log.debug("#{@new_resource} site does not exist - nothing to do")
  end
end

action :start do
  unless @current_resource.running
    shell_out!("#{appcmd} start site /site.name:\"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} started")
  else
    Chef::Log.debug("#{@new_resource} already running - nothing to do")
  end
end

action :stop do
  if @current_resource.running
    shell_out!("#{appcmd} stop site /site.name:\"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} stopped")
  else
    Chef::Log.debug("#{@new_resource} already stopped - nothing to do")
  end
end

action :restart do
  shell_out!("#{appcmd} stop site /site.name:\"#{site_identifier}\"")
  sleep 2
  shell_out!("#{appcmd} start site /site.name:\"#{site_identifier}\"")
  @new_resource.updated_by_last_action(true)
  Chef::Log.info("#{@new_resource} restarted")
end

def load_current_resource
  @current_resource = Chef::Resource::IisSite.new(@new_resource.name)
  @current_resource.site_name(@new_resource.site_name)
  cmd = shell_out("#{appcmd} list site")
  # 'SITE "Default Web Site" (id:1,bindings:http/*:80:,state:Started)'
  Chef::Log.debug("#{@new_resource} list site command output: #{cmd.stdout}")
  result = cmd.stdout.match(/^SITE\s\"(#{@new_resource.site_name})\"\s\(id:(.*),bindings:(.*),state:(.*)\)$/) if cmd.stderr.empty?
  Chef::Log.debug("#{@new_resource} current_resource match output: #{result}")
  if result
    @current_resource.site_id(result[2].to_i)
    @current_resource.exists = true
    bindings = result[3]
    @current_resource.running = (result[4] =~ /Started/) ? true : false
  else
    @current_resource.exists = false
    @current_resource.running = false
  end
end

private
def appcmd
  @appcmd ||= begin
    "#{node['iis']['home']}\\appcmd.exe"
  end
end

def site_identifier
  @new_resource.host_header || @new_resource.site_name 
end