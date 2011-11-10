#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/provider'

class Chef
  class Provider
    class Database
      class Postgresql < Chef::Provider
        include Chef::Mixin::ShellOut

        def load_current_resource
          Gem.clear_paths
          require 'pg'
          @current_resource = Chef::Resource::Database.new(@new_resource.name)
          @current_resource.database_name(@new_resource.database_name)
          @current_resource
        end

        def action_create
          unless exists?
            begin
              Chef::Log.debug("#{@new_resource}: Creating database #{new_resource.database_name}")
              db.query("create database #{new_resource.database_name}")
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        def action_drop
          if exists?
            begin
              Chef::Log.debug("#{@new_resource}: Dropping database #{new_resource.database_name}")
              db.query("drop database #{new_resource.database_name}")
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        def action_query
          if exists?
            begin
              # FIXME: this needs to be s/mysql/postgresql/ still
              db(@new_resource.database_name) if @new_resource.database_name
              Chef::Log.debug("#{@new_resource}: Performing query [#{new_resource.sql}]")
              db.query(@new_resource.sql)
              @new_resource.updated_by_last_action(true)
            ensure
              close
            end
          end
        end

        private

        def exists?
          db.query("select * from pg_database where datname = '#{@new_resource.database_name}'").num_tuples != 0
        end

        #
        # This is a little strange, but most of the time you're going to want to not specify a database name
        # in your connection attribute and connect to the default "template1" database -- then you can run
        # add/drop database or vacuums or whatever while attatched to that database.  When you want to run a query
        # against a specific database, call this again with the dbname argument not nil.  There is no
        # db.select_db() kind of functionality in postgres, you have to completely reattach to a different database
        # with your connection string. 
        #
        def db(dbname = nil)
          Chef::Log.info("#{@new_resource}: switching database to #{@new_resource.database_name}") if dbname
          if @db.nil? || dbname
            @db = ::PGconn.new(
              :host => @new_resource.connection[:host],
              :port => @new_resource.connection[:port] || 5432,
              :dbname => dbname || @new_resource.connection[:database] || "template1",
              :user => @new_resource.connection[:username] || "postgres",
              :password => @new_resource.connection[:password] || node[:postgresql][:password][:postgres]
            )
          else
            @db
          end
        end

        def close
          @db.close rescue nil
          @db = nil
        end

      end
    end
  end
end
