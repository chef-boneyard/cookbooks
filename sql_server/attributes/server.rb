#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: sql_server
# Attribute:: server
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

default['sql_server']['install_dir']    = 'C:\Program Files\Microsoft SQL Server'
default['sql_server']['port']           = 1433

default['sql_server']['instance_name']  = 'SQLEXPRESS'
default['sql_server']['instance_dir']   = 'C:\Program Files\Microsoft SQL Server'

if kernel['machine'] =~ /x86_64/

  default['sql_server']['server']['url']          = 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe'
  default['sql_server']['server']['checksum']     = '6840255cf493927a3f5e1d7f865b8409ed89133e3657a609da229bab4005b613'
  default['sql_server']['server']['package_name'] = 'Microsoft SQL Server 2008 R2 (64-bit)'

else

  default['sql_server']['server']['url']          = 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR32_x86_ENU.exe'
  default['sql_server']['server']['checksum']     = '24f75df802a406cf32e854a60b0c340a50865fb310c0f74c7cecc918cff6791c'
  default['sql_server']['server']['package_name'] = 'Microsoft SQL Server 2008 R2 (32-bit)'

end
