begin
  require 'mysql'
rescue LoadError
  Chef::Log.warn("Missing gem 'mysql'")
end

module Opscode
  module Mysql
    module Database
      def db
        @@db ||= ::Mysql.new new_resource.host, new_resource.username, new_resource.password
      end
    end
  end
end
