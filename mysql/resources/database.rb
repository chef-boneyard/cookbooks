actions :flush_tables_with_read_lock, :unflush_tables, :create_db, :query

attribute :host, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String
attribute :sql, :kind_of => String
attribute :exists, :default => false
