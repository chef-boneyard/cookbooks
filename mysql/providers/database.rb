include Opscode::Mysql::Database

action :flush_tables_with_read_lock do
  Chef::Log.info "mysql_database: flushing tables with read lock"
  db.query "flush tables with read lock"
  new_resource.updated = true
end

action :unflush_tables do
  Chef::Log.info "mysql_database: unlocking tables"
  db.query "unlock tables"
  new_resource.updated = true
end
