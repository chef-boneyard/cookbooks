#
# Cookbook Name:: postgresql
# Provider:: database
#
# Copyright:: 2008-2011, Opscode, Inc <legal@opscode.com>
# Copyright:: 2011, Atriso BVBA, <ringo.de.smet@atriso.be>
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

include Opscode::PostgreSQL::Connection

action :create do
  unless exists?
    begin
      connection.exec("create database #{new_resource.database}")
      Chef::Log.info "postgresql_database: Created database #{new_resource.database}"
      new_resource.updated_by_last_action(true)
    ensure
      close
    end
  end

end

def load_current_resource
  Gem.clear_paths
  require 'pg'

  @current_resource = Chef::Resource::PostgresqlDatabase.new(@new_resource.name)

  begin
    query_result = connection.exec("select * from pg_database where datname = '#{@new_resource.database}';")
    if query_result.ntuples > 0
      existing_role_values = query_result.values[0]
      @current_resource.database(existing_role_values[0])
    end
  ensure
    close
  end

  @current_resource
end

private
def exists?
  begin
    query_result = connection.exec('select datname from pg_database;')
    databases = query_result.column_values(0)
    close
    databases.include?(new_resource.database)
  ensure
    close
  end
end
