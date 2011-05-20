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
  version = node.platform_version.to_f
  
  case version
  when 5.1..6.0

    # TODO: move this to a library and create value_for_version_and_arch method
    value_for_version_and_arch = {5.1 => { # Windows XP
                                      'i386' => ["http://download.microsoft.com/download/E/C/E/ECE99583-2003-455D-B681-68DB610B44A4/WindowsXP-KB968930-x86-ENG.exe", "0ef2a9b4f500b66f418660e54e18f5f525ed8d0a4d7c50ce01c5d1d39767c00c"]
                                    },
                                  5.2 => { # Windows Server 2003
                                      'i386' => ["http://download.microsoft.com/download/1/1/7/117FB25C-BB2D-41E1-B01E-0FEB0BC72C30/WindowsServer2003-KB968930-x86-ENG.exe", "71b180e0affd9e005d7151a656414176e727b6dc80a9350e7b2b23bcac0cc98a"],
                                      'x86_64' => ["http://download.microsoft.com/download/B/D/9/BD9BB1FF-6609-4B10-9334-6D0C58066AA7/WindowsServer2003-KB968930-x64-ENG.exe", "9f5d24517f860837daaac062e5bf7e6978ceb94e4e9e8567798df6777b56e4c8"]
                                    },
                                  6.0 => { # Windows Server 2008 & Windows Vista
                                      'i386' => ["http://download.microsoft.com/download/F/9/E/F9EF6ACB-2BA8-4845-9C10-85FC4A69B207/Windows6.0-KB968930-x86.msu", "1c1fee616014da6e52aa7a117b9bcc3a79ac3d838d686b8afe4f723630225fa2"],
                                      'x86_64' => ["http://download.microsoft.com/download/2/8/6/28686477-3242-4E96-9009-30B16BED89AF/Windows6.0-KB968930-x64.msu", "19bd295d354538873afccc7c9a090ae6ba87beb968b20e8280bf5312826de9e3"]
                                    }
                                  }

    download_url = value_for_version_and_arch[version][node['kernel']['machine']]
    base_name = download_url[0].split(/\//)[-1]

    unless installed?
      # start ocsetup MicrosoftWindowsPowerShell
      remote_file "#{Chef::Config[:file_cache_path]}/#{base_name}" do
        source download_url[0]
        checksum download_url[1]
        mode "0644"
        notifies :run, 'execute[install-powershell-2]', :immediately
      end
      execute "install-powershell-2" do
        command "#{File.join(Chef::Config[:file_cache_path], base_name).gsub!(File::SEPARATOR, File::ALT_SEPARATOR)} /quiet /norestart"
        returns [0,1,nil]
        action :nothing
        notifies :create, 'ruby_block[log-restart-message]', :immediately
      end
      ruby_block "log-restart-message" do
        block do
          Chef::Log.warn("Powershell 2.0 was successfully installed.  The node may need to be restarted for changes to take effect.")
        end
        action :nothing
      end
    else
      Chef::Log.info("PowerShell 2.0 is already installed and enabled on this node.")
    end
  when 6.1 # Windows Server 2008 R2 & Windows 7
    # Windows Server 2008 R2 Core does not come
    # with .NET or Powershell 2.0 enabled
    unless installed?
      # TODO create a .NET cookbook
      execute "enable-dot-net" do
        command "start /w ocsetup NetFx2-ServerCore"
        action :run
      end
      execute "enable-powershell-2" do
        command "start /w ocsetup MicrosoftWindowsPowerShell"
        action :run
      end
    else
      Chef::Log.info("PowerShell 2.0 is already enabled on this version of Windows: #{node.platform_version}")
    end
  else
    Chef::Log.warn("PowerShell 2.0 is not supported on this version of Windows: #{node.platform_version}")
  end
else
  Chef::Log.warn('PowerShell 2.0 can only be installed on the Windows platform.')
end
