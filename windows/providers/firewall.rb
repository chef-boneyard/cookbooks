#
# Cookbook Name:: windows
# Provider:: firewall 
# Author: Kendrick Martin
#
# Copyright 2011, Webtrends
#
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

action :open_port do
	unless @current_portopening.exists
		Chef::Log.debug("Opening Fireawll port  #{@new_resource.rule_name}")
		cmd = "#{firewallcmd} set portopening protocol=#{@new_resource.protocol} "
		cmd << "port=#{@new_resource.port} name=#{@new_resource.rule_name}"
		shell_out!(cmd)
		Chef::Log.info("#{@new_resource.rule_name} firewall port opened")
	else
		Chef::Log.info("#{@new_resource.rule_name} Port already open")
	end
end

def load_current_resource
	@current_portopening = Chef::Resource::WindowsFirewall.new(@new_resource.name)
	@current_portopening.rule_name(@new_resource.rule_name)
	cmd = shell_out("#{firewallcmd} show portopening")
	Chef::Log.debug("#{@new_resource} show portopening command output: #{cmd.stdout}")
	result = cmd.stdout.match(/^#{new_resource.port}\s*#{new_resource.protocol}.*#{new_resource.rule_name}/) if cmd.stderr.empty?
  Chef::Log.debug("#{@new_resource} current_portopening match output: #{result}")
  if result    
    @current_portopening.exists = true  
  else
    @current_portopening.exists = false
  end
end

private
def firewallcmd
  @firewall ||= begin
    "netsh firewall"
  end
end