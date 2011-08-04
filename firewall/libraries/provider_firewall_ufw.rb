#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/log'
require 'chef/provider'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class Firewall
      class Ufw < Chef::Provider
        include Chef::Mixin::ShellOut

        def load_current_resource
          @current_resource = Chef::Resource::Firewall.new(@new_resource.name)
        end

        def action_enable
          unless active?
            shell_out!("echo yes | ufw enable")
            Chef::Log.info("#{@new_resource} enabled")
            @new_resource.updated_by_last_action(true)
          else
            Chef::Log.debug("#{@new_resource} already enabled.")
          end
        end

        def action_disable
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
      end
    end
  end
end

Chef::Platform.set(
  :platform => :ubuntu,
  :resource => :firewall,
  :provider => Chef::Provider::Firewall::Ufw
)
