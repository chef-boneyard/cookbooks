#
# Author:: Kendrick Martin (kendrick.martin@webtrends.com)
# Cookbook Name:: iis
# Provider:: app
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
	cmd = "#{appcmd} add app /site.name:\"#{@new_resource.app_name}\""
	cmd << " /path:#{@new_resource.path}"
	cmd << " /applicationPool:#{@new_resource.application_pool}"
	cmd << " /physicalPath:\"#{@new_resource.physical_path}\""
	Chef::Log.debug(cmd)
	shell_out!(cmd)
	Chef::Log.info("App created")
	else
    Chef::Log.debug("#{@new_resource} app already exists - nothing to do")
  end
end

action :delete do
  if @current_resource.exists
    shell_out!("#{appcmd} delete app \"#{site_identifier}\"")
    @new_resource.updated_by_last_action(true)
    Chef::Log.info("#{@new_resource} deleted")
  else
    Chef::Log.debug("#{@new_resource} app does not exist - nothing to do")
  end
end

def load_current_resource
  @current_resource = Chef::Resource::IisApp.new(@new_resource.name)
  @current_resource.app_name(@new_resource.app_name)
  @current_resource.path(@new_resource.path)
  @current_resource.application_pool(@new_resource.application_pool)
  cmd = shell_out("#{appcmd} list app")
  # APPPOOL "MyAppName" (applicationPool:MyAppPool)
  Chef::Log.debug("#{@new_resource} list app command output: #{cmd.stdout}")
  #result = cmd.stdout.match(/^APP\s\"#{@new_resource.app_name}#{@new_resource.path}\"/) if cmd.stderr.empty?
  result = cmd.stdout.match(/^APP\s\"#{@new_resource.app_name}#{@new_resource.path}\"\s\(applicationPool\:#{@new_resource.application_pool}\)/) if cmd.stderr.empty?
         Chef::Log.debug("Running regex")
  Chef::Log.debug("#{@new_resource} current_resource match output:#{result}")
  if result
    @current_resource.exists = true
  else
    @current_resource.exists = false
  end
end

private
def appcmd
  @appcmd ||= begin
    "#{node['iis']['home']}\\appcmd.exe"
  end
end

def site_identifier
  "#{@new_resource.app_name}#{@new_resource.path}"
end
