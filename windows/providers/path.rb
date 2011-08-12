#
# Author:: Paul Morotn (<pmorton@biaprotect.com>)
# Cookbook Name:: windows
# Provider:: path
#
# Copyright:: 2011, Business Intelligence Associates, Inc
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

action :add do
  path = ENV['PATH'].split(';')
  if !path.include?(new_resource.path)
    path.insert(-1,new_resource.path)
  end

  windows_registry Windows::KeyHelper::ENV_KEY do
    values 'Path' => path.join(';')
  end
  timeoutVars
end

action :remove do
  path = ENV['PATH'].split(';')
  path.delete(new_resource.path)
  windows_registry Windows::KeyHelper::ENV_KEY do
    values 'Path' => path.join(';')
  end
  timeoutVars
end

private 
# Notify all processes that the environmental variables have been updated.
def timeoutVars
  # Dosent seem to work... You may need to re-login
  Chef::Log.debug("Telling other processes that the env vars have been updated")
  require 'Win32API'
  sendMessageTimeout = Win32API.new('user32', 'SendMessageTimeout', 'LLLPLLP', 'L') 
  hwnd_broadcast = 0xffff
  wm_settingchange = 0x001A
  smto_abortifhung = 2
  result = 0
  sendMessageTimeout.call(hwnd_broadcast, wm_settingchange, 0, 'Environment', smto_abortifhung, 5000, result)
end