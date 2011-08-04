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

require 'chef/resource'

class Chef
  class Resource
    class FirewallRule < Chef::Resource

      IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/

      def initialize(name, run_context=nil)
        super
        @resource_name = :firewall_rule
        @source = "0.0.0.0/0"
        @allowed_actions.push(:allow, :deny)
      end

      def port(arg=nil)
        set_or_return(
          :port,
          arg,
          :required => true
        )
      end

      def protocol(arg=nil)
        real_arg = arg.kind_of?(String) ? arg.to_sym : arg
        set_or_return(
          :protocol,
          real_arg,
          :equal_to => [ :udp, :tcp ]
        )
      end

      def source(arg=nil)
        set_or_return(
          :source,
          arg,
          :regex => IP_CIDR_VALID_REGEX
        )
      end

      def destination(arg=nil)
        set_or_return(
          :destination,
          arg,
          :regex => IP_CIDR_VALID_REGEX
        )
      end

      def position(arg=nil)
        set_or_return(
          :position,
          arg,
          :kind_of => Integer
        )
      end
    end
  end
end
