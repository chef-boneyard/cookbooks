#
# Cookbook Name:: mysql
# Provider:: database
#
# Copyright:: 2008-2011, Opscode, Inc <legal@opscode.com>
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

include Opscode::Mysql::Database

action :flush_tables_with_read_lock do
  if exists?
    begin
      Chef::Log.info "mysql_database: flushing tables with read lock"
      db.query "flush tables with read lock"
      new_resource.updated_by_last_action(true)
    ensure
      db.close
    end
  end
end

action :unflush_tables do
  if exists?
    begin
      Chef::Log.info "mysql_database: unlocking tables"
      db.query "unlock tables"
      new_resource.updated_by_last_action(true)
    ensure
      db.close
    end
  end
end

action :create_db do
  unless exists?
    begin
      Chef::Log.info "mysql_database: Creating database #{new_resource.database}"
      db.query("create database #{new_resource.database}")
      new_resource.updated_by_last_action(true)
    ensure
      db.close
    end
  end
end

action :query do
  if exists?
    begin
      Chef::Log.info "mysql_database: Performing Query: #{new_resource.sql}"
      db.query(new_resource.sql)
      new_resource.updated_by_last_action(true)
    ensure
      db.close
    end
  end
end

def load_current_resource
  Gem.clear_paths
  require 'mysql'

  @mysqldb = Chef::Resource::MysqlDatabase.new(new_resource.name)
  @mysqldb.database(new_resource.database)
end

private
def exists?
  db.list_dbs.include?(new_resource.database)
end
