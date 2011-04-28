begin
  require 'pg'
rescue LoadError
  Chef::Log.debug("Missing gem 'pg'")
end

module PostgreSQL
  module Database
    def db
      @@db ||= ::PGconn.new(
        :host => new_resource.host,
        :port => new_resource.port,
        :user => new_resource.username,
        :password =>new_resource.password
      )
    end
  end
end
