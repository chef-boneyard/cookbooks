#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: sql_server
# Attribute:: client
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

if kernel['machine'] =~ /x86_64/

  default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/sqlncli.msi'
  default['sql_server']['native_client']['checksum']          = '012aca6cef50ed784f239d1ed5f6923b741d8530b70d14e9abcb3c7299a826cc'
  default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

  default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SqlCmdLnUtils.msi'
  default['sql_server']['command_line_utils']['checksum']     = '5a321cad6c5f0f5280aa73ab8ed695f8a6369fa00937df538a971729552340b8'
  default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

  default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SQLSysClrTypes.msi'
  default['sql_server']['clr_types']['checksum']              = '0ad774b0d124c83bbf0f31838ed9c628dd76d83ab2c8c57fd5e2f5305580fff2'
  default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

  default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SharedManagementObjects.msi'
  default['sql_server']['smo']['checksum']                    = 'dccec315e3c345a7efb5951f3e9b27512b4e91d73ec48c7196633b7449115b7c'
  default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

  default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/PowerShellTools.msi'
  default['sql_server']['ps_extensions']['checksum']          = 'eeb46c297523c7de388188ba27263a51b75e85efd478036a12040cc04d4ab344'
  default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'

else

  default['sql_server']['native_client']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/sqlncli.msi'
  default['sql_server']['native_client']['checksum']          = '35c4b98f7f5f951cae9939c637593333c44aee920efbd4763b7bdca1e23ac335'
  default['sql_server']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

  default['sql_server']['command_line_utils']['url']          = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SqlCmdLnUtils.msi'
  default['sql_server']['command_line_utils']['checksum']     = 'b39981fa713feedaaf532ab393bf312ec7b5f63bb5f726b9d0e1ae5a65350eee'
  default['sql_server']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

  default['sql_server']['clr_types']['url']                   = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SQLSysClrTypes.msi'
  default['sql_server']['clr_types']['checksum']              = '6166f2fa57fb971699ff66461434b2418820306c094b5dc3e7df1b827275bf20'
  default['sql_server']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x86)'

  default['sql_server']['smo']['url']                         = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SharedManagementObjects.msi'
  default['sql_server']['smo']['checksum']                    = '4b1ec03bc5cc69481b9da6b2db41ae6d3adeacffe854cc209d125e83a739f937'
  default['sql_server']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x86)'

  default['sql_server']['ps_extensions']['url']               = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/PowerShellTools.msi'
  default['sql_server']['ps_extensions']['checksum']          = 'b0d63f8d3e3455fd390dfa0fefebde245bf1a272eb96a968d025f2cbd7842b6c'
  default['sql_server']['ps_extensions']['package_name']      = 'Windows PowerShell Extensions for SQL Server 2008 R2'

end
