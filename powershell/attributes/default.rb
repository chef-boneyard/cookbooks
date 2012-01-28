#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: powershell
# Attribute:: default
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

case platform_version.to_f
when 5.1 # Windows XP
  default['powershell']['url']      = "http://download.microsoft.com/download/E/C/E/ECE99583-2003-455D-B681-68DB610B44A4/WindowsXP-KB968930-x86-ENG.exe"
  default['powershell']['checksum'] = "0ef2a9b4f500b66f418660e54e18f5f525ed8d0a4d7c50ce01c5d1d39767c00c"

when 5.2 # Windows Server 2003
  if kernel.machine =~ /x86_64/
    default['powershell']['url']      = "http://download.microsoft.com/download/B/D/9/BD9BB1FF-6609-4B10-9334-6D0C58066AA7/WindowsServer2003-KB968930-x64-ENG.exe"
    default['powershell']['checksum'] = "9f5d24517f860837daaac062e5bf7e6978ceb94e4e9e8567798df6777b56e4c8"
  else
    default['powershell']['url']      = "http://download.microsoft.com/download/1/1/7/117FB25C-BB2D-41E1-B01E-0FEB0BC72C30/WindowsServer2003-KB968930-x86-ENG.exe"
    default['powershell']['checksum'] = "71b180e0affd9e005d7151a656414176e727b6dc80a9350e7b2b23bcac0cc98a"
  end

when 6.0 # Windows Server 2008 & Windows Vista
  if kernel.machine =~ /x86_64/
    default['powershell']['url']      = "http://download.microsoft.com/download/2/8/6/28686477-3242-4E96-9009-30B16BED89AF/Windows6.0-KB968930-x64.msu"
    default['powershell']['checksum'] = "19bd295d354538873afccc7c9a090ae6ba87beb968b20e8280bf5312826de9e3"
  else
    default['powershell']['url']      = "http://download.microsoft.com/download/F/9/E/F9EF6ACB-2BA8-4845-9C10-85FC4A69B207/Windows6.0-KB968930-x86.msu"
    default['powershell']['checksum'] = "1c1fee616014da6e52aa7a117b9bcc3a79ac3d838d686b8afe4f723630225fa2"
  end

end
