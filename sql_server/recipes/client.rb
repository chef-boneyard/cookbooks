#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: sql_server
# Recipe:: client
#
# Copyright:: 2011, Opscode, Inc.
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

# server installer includes client packages
unless node.recipe?("sql_server::server")

  %w{ native_client command_line_utils clr_types smo ps_extensions }.each do |pkg|

    windows_package node['sql_server'][pkg]['package_name'] do
      source node['sql_server'][pkg]['url']
      checksum node['sql_server'][pkg]['checksum']
      installer_type :msi
      options "IACCEPTSQLNCLILICENSETERMS=#{node['sql_server']['accept_eula'] ? 'YES' : 'NO'}"
      action :install
    end

  end

  # update path
  windows_path 'C:\Program Files\Microsoft SQL Server\100\Tools\Binn' do
   action :add
  end

end

# used by SQL Server providers for 
# database and database_user resources
gem_package "tiny_tds" do
  action :install
end