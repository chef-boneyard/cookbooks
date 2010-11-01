include Opscode::Mysql::Database

action :flush_tables_with_read_lock do
  Chef::Log.info "mysql_database: flushing tables with read lock"
  db.query "flush tables with read lock"
  new_resource.updated_by_last_action(true)
end

action :unflush_tables do
  Chef::Log.info "mysql_database: unlocking tables"
  db.query "unlock tables"
  new_resource.updated_by_last_action(true)
end

action :create_db do
  unless @mysqldb.exists
    Chef::Log.info "mysql_database: Creating database #{new_resource.database}"
    db.query("create database #{new_resource.database}")
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @mysqldb = Chef::Resource::MysqlDatabase.new(new_resource.name)
  @mysqldb.database(new_resource.database)
  exists = db.list_dbs.include?(new_resource.database)
  @mysqldb.exists(exists)
end
