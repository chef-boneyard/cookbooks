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

require 'chef/mixin/shell_out'
require 'chef/log'
require 'chef/provider'

class Chef
  class Provider
    class WindowsFeature < Chef::Provider

      include Chef::Mixin::ShellOut
      include Windows::Helper

      def initialize(new_resource, run_context)
        super
      end

      def action_install
        unless installed?
          install_feature(@new_resource.feature_name)
          @new_resource.updated_by_last_action(true)
          Chef::Log.info("#{@new_resource} installed feature")
        else
          Chef::Log.debug("#{@new_resource} is already installed - nothing to do")
        end
      end

      def action_remove
        if installed?
          remove_feature(@new_resource.feature_name)
          @new_resource.updated_by_last_action(true)
          Chef::Log.info("#{@new_resource} removed")
        else
          Chef::Log.debug("#{@new_resource} feature does not exist - nothing to do")
        end
      end

      def install_feature(name)
        raise Chef::Exceptions::UnsupportedAction, "#{self.to_s} does not support :install"
      end

      def remove_feature(name)
        raise Chef::Exceptions::UnsupportedAction, "#{self.to_s} does not support :remove"
      end
      
      def installed?
        raise Chef::Exceptions::Override, "You must override installed? in #{self.to_s}"
      end
    end
  end
end
