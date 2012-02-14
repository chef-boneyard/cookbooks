#
# Author:: Kendrick Martin (kendrick.martin@webtrends.com)
# Cookbook Name:: iis
# Provider:: site
#
# Copyright:: 2011, Webtrends
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
	cmd = "#{appcmd} add apppool /name:\"#{@new_resource.pool_name}\""
	cmd << " /managedRuntimeVersion:v#{@new_resource.runtime_version}" if @new_resource.runtime_version
	cmd << " /managedPipelineMode:#{@new_resource.pipeline_mode}" if @new_resource.pipeline_mode
	Chef::Log.debug(cmd)
	shell_out!(cmd)
	@new_resource.updated_by_last_action(true)
	Chef::Log.info("App pool created")
  else
    Chef::Log.debug("#{@new_resource} pool already exists - nothing to do")
  end
end

action :config do
	cmd = "#{appcmd} set config /section:applicationPools "
	cmd << "/[name='#{@new_resource.pool_name}'].recycling.logEventOnRecycle:PrivateMemory,Memory,Schedule,Requests,Time,ConfigChange,OnDemand,IsapiUnhealthy"
	Chef::Log.debug(cmd)
	shell_out!(cmd)	
	cmd = "#{appcmd} set config /section:applicationPools /[name='#{@new_resource.pool_name}'].recycling.periodicRestart.privateMemory:#{@new_resource.private_mem}"
	Chef::Log.debug(cmd)
	shell_out!(cmd)
	cmd = "#{appcmd} set apppool \"#{@new_resource.pool_name}\" -processModel.maxProcesses:#{@new_resource.max_proc}"
	Chef::Log.debug(cmd)
	shell_out!(cmd)
	cmd = "#{appcmd} set apppool /apppool.name:#{@new_resource.pool_name} /enable32BitAppOnWin64:#{@new_resource.thirty_two_bit}"
	Chef::Log.debug(cmd)
	shell_out!(cmd)
end

action :delete do
  if @current_resource.exists
    shell_out!("#{appcmd} delete apppool \"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} deleted")
  else
    Chef::Log.debug("#{@new_resource} pool does not exist - nothing to do")
  end
end

action :start do
  unless @current_resource.running
    shell_out!("#{appcmd} start appool \"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} started")
  else
    Chef::Log.debug("#{@new_resource} already running - nothing to do")
  end
end

action :stop do
  if @current_resource.running
    shell_out!("#{appcmd} stop appool \"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} stopped")
  else
    Chef::Log.debug("#{@new_resource} already stopped - nothing to do")
  end
end

action :restart do
  shell_out!("#{appcmd} stop APPPOOL \"#{site_identifier}\"")
  sleep 2
  shell_out!("#{appcmd} start APPPOOL \"#{site_identifier}\"")
  @new_resource.updated_by_last_action(true)
  Chef::Log.info("#{@new_resource} restarted")
end

def load_current_resource
  @current_resource = Chef::Resource::IisPool.new(@new_resource.name)
  @current_resource.pool_name(@new_resource.pool_name)
  cmd = shell_out("#{appcmd} list apppool")
  # APPPOOL "DefaultAppPool" (MgdVersion:v2.0,MgdMode:Integrated,state:Started)
  Chef::Log.debug("#{@new_resource} list apppool command output: #{cmd.stdout}")
  result = cmd.stdout.match(/^APPPOOL\s\"#{@new_resource.pool_name}.*/) if cmd.stderr.empty?
  Chef::Log.debug("#{@new_resource} current_resource match output: #{result}")
  if result    
    @current_resource.exists = true    
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
  @new_resource.pool_name 
end