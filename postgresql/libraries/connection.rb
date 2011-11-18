begin
  require 'pg'
rescue LoadError
  Chef::Log.info("Missing gem 'pg'")
end

module Opscode
  module PostgreSQL

    module Connection
      def connection
        unless @connection
          Chef::Log.debug("Connecting to #{new_resource.db_host}:#{new_resource.db_port}, user '#{new_resource.db_username}'")
          password = (new_resource.db_password or node[:postgresql][:password][:postgres])
          @connection ||= ::PGconn.connect(
                                           :host => new_resource.db_host,
                                           :port => new_resource.db_port,
                                           :user => new_resource.db_username,
                                           :password => password
                                          )
          Chef::Log.debug("Created postgresql connection: #{@connection} - status: #{@connection.status}")
        end
        @connection
      end
      def close
        Chef::Log.debug("Closing postgresql connection: #{@connection}")
        @connection.finish rescue nil
        @connection = nil
      end
    end
  end
end
