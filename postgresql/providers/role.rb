#
# Cookbook Name:: postgresql
# Provider:: role
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
  action = ''
  command = ''
  unless exists?
    command += "create role #{new_resource.role}"
    action = 'Created'
  else
    command += "alter role #{new_resource.role}"
    action = 'Altered'
  end
  command += " superuser" if new_resource.superuser
  command += " inherit" if new_resource.inherit
  command += " createrole" if new_resource.createrole
  command += " createdb" if new_resource.createdb
  command += " login" if new_resource.login

  begin
    connection.exec(command)
    Chef::Log.info "postgresql_role: #{action} role #{new_resource.role}"
    new_resource.updated_by_last_action(true)
  ensure
    close
  end
end

def load_current_resource
  Gem.clear_paths
  require 'pg'

  @current_resource = Chef::Resource::PostgresqlRole.new(@new_resource.name)

  begin
    query_result = connection.exec("select * from pg_roles where rolname = '#{@new_resource.role}';")
    if query_result.ntuples > 0
      existing_role_values = query_result.values[0]
      @current_resource.role(existing_role_values[0])
      @current_resource.superuser(bool_convert existing_role_values[1])
      @current_resource.inherit(bool_convert existing_role_values[2])
      @current_resource.createrole(bool_convert existing_role_values[3])
      @current_resource.createdb(bool_convert existing_role_values[4])
      @current_resource.login(bool_convert existing_role_values[6])
    end
  ensure
    close
  end

  @current_resource
end

private
def exists?
  begin
    query_result = connection.exec('select rolname from pg_roles;')
    roles = query_result.column_values(0)
    close
    roles.include?(new_resource.role)
  ensure
    close
  end
end

def bool_convert(db_bool_value)
  case db_bool_value
    when 'f'
      false
    when 't'
      true
  end
end