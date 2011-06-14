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

require 'chef/resource/execute'
require 'chef/resource/script'

# PLEASE NOTE - This is not a good example of shipping a Resource/Provider 
# with a cookbook.  Please check the Chef Wiki for more traditional DSL driven 
# LWRPs.  This 'heavyweight' resource will eventually be moved into Core Chef.

class Chef
  class Resource
    class Powershell < Chef::Resource::Script

      def initialize(name, run_context=nil)
        super
        @resource_name = :powershell
        @provider = Chef::Provider::PowershellScript
        @interpreter = locate_powershell_interperter
        @returns = [0,42] # successful commands return exit code 42
      end

      private
        def locate_powershell_interperter
          # force 64-bit powershell from 32-bit ruby process
          if ::File.exist?("c:/windows/sysnative/WindowsPowershell/v1.0/powershell.exe") 
            "c:/windows/sysnative/WindowsPowershell/v1.0/powershell.exe"
          elsif ::File.exist?("c:/windows/system32/WindowsPowershell/v1.0/powershell.exe")
            "c:/windows/system32/WindowsPowershell/v1.0/powershell.exe"
          else
            "powershell.exe"
          end
        end
    end 
  end

  class Provider
    class PowershellScript < Chef::Provider::Execute

      def action_run
        script_file.puts(@new_resource.code)
        script_file.close
        set_owner_and_group
        
        # always set the ExecutionPolicy flag
        # see http://technet.microsoft.com/en-us/library/ee176961.aspx
        @new_resource.flags("#{@new_resource.flags} -ExecutionPolicy RemoteSigned -Command".strip)
        
        # cwd hax...shell_out on windows needs to support proper 'cwd'
        # follow CHEF-2357 for more
        cwd = @new_resource.cwd ? "cd #{@new_resource.cwd} & " : ""
        @new_resource.command("#{cwd}#{@new_resource.interpreter} #{@new_resource.flags} \"#{build_powershell_scriptblock}\"")
        super
      ensure
        unlink_script_file
      end

      def set_owner_and_group
        # FileUtils itself implements a no-op if +user+ or +group+ are nil
        # You can prove this by running FileUtils.chown(nil,nil,'/tmp/file')
        # as an unprivileged user.
        FileUtils.chown(@new_resource.user, @new_resource.group, script_file.path)
      end

      def script_file
        @script_file ||= Tempfile.open(['chef-script', '.ps1'])
      end

      def unlink_script_file
        @script_file && @script_file.close!
      end

      private
      # take advantage of PowerShell scriptblocks
      # to pass scoped environment variables to the 
      # command
      def build_powershell_scriptblock
        # environment var hax...shell_out on windows needs to support proper 'environment'
        # follow CHEF-2358 for more
        env_string = if @new_resource.environment
          @new_resource.environment.inject("") {|a, (k,v)| a << "$#{k} = '#{v}'; "; a}
        else
          ""
        end
        "& { #{env_string}#{ensure_windows_friendly_path(script_file.path)} }"
      end
    end 
  end
  
  module Mixin
    module Language
      def ensure_windows_friendly_path(path)
        if path
          path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
        else
          path
        end
      end
    end
  end
end
Chef::Platform.platforms[:default].merge! :powershell => Chef::Provider::PowershellScript