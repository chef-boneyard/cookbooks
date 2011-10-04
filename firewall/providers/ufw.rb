#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: firwall
# Provider:: ufw
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

include Chef::Mixin::ShellOut

action :enable do
  unless active?
    shell_out!("echo yes | ufw enable")
    Chef::Log.info("#{@new_resource} enabled")
    if @new_resource.log_level
      shell_out!("ufw logging #{@new_resource.log_level}") 
      Chef::Log.info("#{@new_resource} logging enabled at '#{@new_resource.log_level}' level")
    end
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{@new_resource} already enabled.")
  end
end

action :disable do
  if active?
    shell_out!("ufw disable")
    Chef::Log.info("#{@new_resource} disabled")
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{@new_resource} already disabled.")
  end
end
  
private
def active?
  @active ||= begin
    cmd = shell_out!("ufw status")
    cmd.stdout =~ /^Status:\sactive/
  end
end
