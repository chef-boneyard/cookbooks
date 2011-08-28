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
      class UfwRule < Chef::Provider
        include Chef::Mixin::ShellOut

        def load_current_resource
          @current_resource = Chef::Resource::FirewallRule.new(@new_resource.name)
        end

        def action_allow
          apply_rule('allow')
        end

        def action_deny
          apply_rule('deny')
        end

        def action_reject
          apply_rule('reject')
        end

        private
        # ufw allow from 192.168.0.4 to any port 22
        # ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port 25
        # ufw insert 1 allow proto tcp from 0.0.0.0/0 to 192.168.0.1 port 25
        def apply_rule(type=nil)
          unless rule_exists?
            ufw_command = "ufw "
            ufw_command += "insert #{@new_resource.position} " if @new_resource.position
            ufw_command += "#{type} "
            ufw_command += "#{@new_resource.direction} " if @new_resource.direction
            if @new_resource.interface
              if @new_resource.direction
                ufw_command += "on #{@new_resource.interface} "
              else
                ufw_command += "in on #{@new_resource.interface} "
              end
            end
            ufw_command += "proto #{proto} "
            if @new_resource.source
              ufw_command += "from #{@new_resource.source} "
            else
              ufw_command += "from any "
            end
            ufw_command += "port #{@new_resource.dest_port} " if @new_resource.dest_port
            if @new_resource.destination
              ufw_command += "to #{@new_resource.destination} "
            else
              ufw_command += "to any "
            end
            ufw_command += "port #{@new_resource.port} " if @new_resource.port

            Chef::Log.debug("ufw: #{ufw_command}")
            shell_out!(ufw_command)

            Chef::Log.info("#{@new_resource} #{type} rule added")
            shell_out!("ufw status") # purely for the Chef::Log.debug output
            @new_resource.updated_by_last_action(true)
          else
            Chef::Log.debug("#{@new_resource} #{type} rule exists..skipping.")
          end
        end

        def proto
          if @new_resource.protocol && @new_resource.protocol == 1
            @new_resource.protocol[0].to_s
          else
            'any'
          end
        end

        def port_and_proto
          (proto && proto != 'any') ? "#{@new_resource.port}/#{proto}" : @new_resource.port
        end

        # TODO currently only works when firewall is enabled
        def rule_exists?
          # To                         Action      From
          # --                         ------      ----
          # 22                         ALLOW       Anywhere
          # 192.168.0.1 25/tcp         DENY        10.0.0.0/8
          shell_out!("ufw status").stdout =~ /^(#{@new_resource.destination}\s)?#{port_and_proto}\s.*(#{@new_resource.action.to_s})\s.*#{@new_resource.source || 'Anywhere'}$/i
        end
      end
    end
  end
end

Chef::Platform.set(
  :platform => :ubuntu,
  :resource => :firewall_rule,
  :provider => Chef::Provider::Firewall::UfwRule
)
