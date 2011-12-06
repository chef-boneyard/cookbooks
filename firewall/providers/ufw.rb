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
  set_policy
end

action :disable do
  if active?
    shell_out!("ufw disable")
    Chef::Log.info("#{@new_resource} disabled")
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{@new_resource} already disabled.")
  end
  set_policy
end

private
def active?
  @active ||= begin
    cmd = shell_out!("ufw status")
    cmd.stdout =~ /^Status:\sactive/
  end
end

def default_policy?(policy)
  @default_policy ||= begin
    cmd = shell_out!("ufw status verbose")
    cmd.stdout =~ /^Default:\s(.*?)\s/
    $1.to_s.strip
  end
  @default_policy == policy.to_s
end

def set_policy
  if default_policy?(@new_resource.policy)
    Chef::Log.debug("#{@new_resource} policy already set to #{@new_resource.policy}.")
  else
    shell_out!("ufw default #{@new_resource.policy}")
    Chef::Log.debug("#{@new_resource} policy set to #{@new_resource.policy}.")
  end
end
