maintainer        "Benjamin Black"
maintainer_email  "b@b3k.us"
license           "Apache 2.0"
description       "Installs and configures RabbitMQ server"
version           "0.1"

%w{ubuntu debian}.each do |os|
  supports os
end

attribute "redis",
  :display_name => "Redis",
  :description => "Hash of Redis attributes",
  :type => "hash"

attribute "redis/address",
  :display_name => "Redis server IP address",
  :description => "IP address to bind.  The default is any.",
  :default => "0.0.0.0"

attribute "redis/port",
  :display_name => "Redis server port",
  :description => "TCP port to bind.  The default is 6379.",
  :default => "6379"

attribute "redis/pidfile",
  :display_name => "Redis PID file path",
  :description => "Path to the PID file when daemonized.  The default is /var/run/redis.pid.",
  :default => "/var/run/redis.pid"

attribute "redis/logfile",
  :display_name => "Redis log file path",
  :description => "Path to the log file when daemonized.  The default is /var/log/redis.log.",
  :default => "/var/log/redis.log"

attribute "redis/dbdir",
  :display_name => "Redis database directory",
  :description => "Path to the directory for database files.  The default is /var/lib/redis.",
  :default => "/var/lib/redis"

attribute "redis/dbfile",
  :display_name => "Redis database filename",
  :description => "Filename for the database storage.  The default is dump.rdb.",
  :default => "dump.rdb"
    
attribute "redis/client_timeout",
  :display_name => "Redis client timeout",
  :description => "Timeout, in seconds, for disconnection of idle clients.  The default is 300 (5 minutes).",
  :default => "300"

attribute "redis/glueoutputbuf",
  :display_name => "Redis output buffer coalescing",
  :description => "Glue small output buffers together into larger TCP packets.  The default is yes.",
  :default => "yes"
  
attribute "redis/saves",
  :display_name => "Redis disk persistence policies",
  :description => "An array of arrays of time, changed objects policies for persisting data to disk.  The default is [[900, 1], [300, 10], [60, 10000]].",
  :default => "[[900, 1], [300, 10], [60, 10000]]"

attribute "redis/slave",
  :display_name => "Redis replication slave",
  :description => "Act as a replication slave to a master redis database.  The default is no.",
  :default => "no"

attribute "redis/master_server",
  :display_name => "Redis replication master server name",
  :description => "The master server for this replication slave.  The default is master-redis.domain.",
  :default => "master-redis.domain"

attribute "redis/master_port",
  :display_name => "Redis replication master server port",
  :description => "The master server port for this replication slave.  The default is 6379.",
  :default => "6379"
  
attribute "redis/sharedobjects",
  :display_name => "Redis shared object compression",
  :description => "Attempt to reduce memory use by sharing storage for substrings.  The default is no.",
  :default => "no"

attribute "redis/shareobjectspoolsize",
  :display_name => "Redis shared object pool size",
  :description => "The size of the pool for object sharing.  The default is 1024.",
  :default => "1024"

