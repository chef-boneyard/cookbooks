#
# Cookbook Name:: postgresql
# Definition:: postgresql_database
#
# Copyright 2010, FindsYou Limited
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

define :postgresql_database, :action => :create, :owner => "postgres" do
  include_recipe "postgresql::server"

  case params[:action]
  when :create
    if params[:template]
      template = "-T #{params[:template]}"
    end

    execute "createdb #{template} #{params[:name]}" do
      user "postgres"
      not_if "psql -f /dev/null #{params[:name]}", :user => "postgres"
    end

    execute "psql -c 'ALTER DATABASE #{params[:name]} OWNER TO #{params[:owner]}'" do
      user "postgres"
    end

    if params[:flags]
      params[:flags].each do |k,v|
        execute "psql -c \"UPDATE pg_catalog.pg_database SET #{k} = '#{v}' WHERE datname = '#{params[:name]}'\" #{params[:name]}" do
          user "postgres"
        end
      end
    end

    modules = params[:modules] || []
    modules = [ *modules ]
    postgis = !modules.delete("postgis").nil?

    languages = params[:languages] || []
    languages = [ *languages ]
    languages << "plpgsql" if postgis

    contrib = node.postgresql.contrib_dir

    languages.uniq.each do |language|
      execute "createlang #{language} #{params[:name]}" do
        user "postgres"
        not_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{params[:name]} | grep '^ #{language}$'", :user => "postgres"
      end
    end

    unless modules.empty?
      version = node.platform == "centos" ? node.postgresql.version.delete(".") : ""
      package "postgresql#{version}-contrib"
    end

    if postgis
      include_recipe "postgresql::postgis"

      # PostGIS 1.4 and above.
      execute "psql -1 -f #{contrib}/postgis.sql #{params[:name]}" do
        user "postgres"
        only_if { File.exists? "#{contrib}/postgis.sql" }
      end

      # PostGIS 1.3 and below.
      execute "psql -1 -f #{contrib}/lwpostgis.sql #{params[:name]}" do
        user "postgres"
        not_if { File.exists? "#{contrib}/postgis.sql" }
      end

      modules << "spatial_ref_sys"
      modules << "postgis_comments"
    end

    modules.uniq.each do |mod|
      execute "psql -1 -f #{contrib}/#{mod}.sql #{params[:name]}" do
        user "postgres"
      end
    end

    if postgis
      %w( geometry_columns spatial_ref_sys ).each do |table|
        execute "psql -c 'ALTER TABLE #{table} OWNER TO #{params[:owner]}' #{params[:name]}" do
          user "postgres"
        end
      end
    end
  when :drop
    execute "psql -c 'DROP DATABASE IF EXISTS #{params[:name]}'" do
      user "postgres"
    end
  end
end
