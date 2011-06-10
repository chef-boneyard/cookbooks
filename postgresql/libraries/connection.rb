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
          Chef::Log.debug("Connecting to 127.0.0.1:5432, user 'postgres'")
          @connection ||= ::PGconn.connect('127.0.0.1', 5432, nil, nil, nil, 'postgres', node[:postgresql][:password][:postgres])
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

    module ConnectionUtils
      def load_role

      end
    end
  end
end

#::PGconn.send(:include, Opscode::PostgreSQL::ConnectionUtils)
