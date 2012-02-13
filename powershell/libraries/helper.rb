#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: powershell
# Library:: helper
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

module Powershell
  module Helper
    include Chef::Mixin::ShellOut

    def powershell_installed?
      begin
        cmd = shell_out("#{interpreter} -inputformat none  -Command \"& {Get-Host}\"")
        cmd.stderr.empty? && (cmd.stdout =~ /Version\s*:\s*2.0/i)
      rescue Errno::ENOENT
        false
      end
    end

    def interpreter
      # force 64-bit powershell from 32-bit ruby process
      if ::File.exist?("#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
      elsif ::File.exist?("#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
      else
        "powershell.exe"
      end
    end
  end
end
