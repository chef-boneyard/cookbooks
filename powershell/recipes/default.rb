#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: powershell
# Recipe:: default
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

::Chef::Recipe.send(:include, Powershell::Helper)

# PowerShell 2.0 Download Page
# http://support.microsoft.com/kb/968929/en-us

case node['platform']
when "windows"

  unless powershell_installed?
    # Windows Server 2008 R2 Core does not come
    # with .NET or Powershell 2.0 enabled
    if (win_version.windows_server_2008_r2? || win_version.windows_7?) && win_version.server_core?

      windows_feature "NetFx2-ServerCore" do
        action :install
      end
      windows_feature "MicrosoftWindowsPowerShell" do
        action :install
      end

    elsif (win_version.windows_server_2008? || win_version.windows_server_2003_r2? ||
            win_version.windows_server_2003? || win_version.windows_xp?)

      if node['kernel']['machine'] =~ /x86_64/
        dot_net_2_url = "http://download.microsoft.com/download/9/8/6/98610406-c2b7-45a4-bdc3-9db1b1c5f7e2/NetFx20SP1_x64.exe"
        dot_net_2_checksum  = "1731e53de5f48baae0963677257660df1329549e81c48b4d7db7f7f3f2329aab"
      else
        dot_net_2_url = "http://download.microsoft.com/download/0/8/c/08c19fa4-4c4f-4ffb-9d6c-150906578c9e/NetFx20SP1_x86.exe"
        dot_net_2_checksum = "c36c3a1d074de32d53f371c665243196a7608652a2fc6be9520312d5ce560871"
      end

      windows_package "Microsoft .NET Framework 2.0 Service Pack 1" do
        source dot_net_2_url
        checksum dot_net_2_checksum
        installer_type :custom
        options "/quiet /norestart"
        action :install
      end

      windows_package "Windows Management Framework Core" do
        source node['powershell']['url']
        checksum node['powershell']['checksum']
        installer_type :custom
        options "/quiet /norestart"
        action :install
      end

    else
      Chef::Log.warn("PowerShell 2.0 is not supported on this version of Windows: #{node.platform_version}")
    end
  else
    Chef::Log.info("PowerShell 2.0 is already installed/enabled.")
  end
else
  Chef::Log.warn('PowerShell 2.0 can only be installed on the Windows platform.')
end
