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
require File.join(File.dirname(__FILE__), 'provider_windows_feature_servermanagercmd')
require File.join(File.dirname(__FILE__), 'provider_windows_feature_dism')
include Windows::Helper

class Chef
  class Resource
    class WindowsFeature < Chef::Resource

      def initialize(name, run_context=nil)
        super
        @resource_name = :windows_feature
        @feature_name = name
        @allowed_actions.push(:install, :remove)
        @action = :install
      end

      def feature_name(arg=nil)
        set_or_return(
          :feature_name,
          arg,
          :kind_of => String
        )
      end

    end
  end
end

# we prefer DISM as ServerManagerCmd is deprecated
if ::File.exists?(locate_sysnative_cmd('dism.exe'))
  Chef::Platform.set(
    :platform => :windows,
    :resource => :windows_feature,
    :provider => Chef::Provider::WindowsFeature::DISM
  )
elsif ::File.exists?(locate_sysnative_cmd('servermanagercmd.exe'))
  Chef::Platform.set(
    :platform => :windows,
    :resource => :windows_feature,
    :provider => Chef::Provider::WindowsFeature::ServerManagerCmd
  )
end