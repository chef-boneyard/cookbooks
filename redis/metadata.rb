maintainer       "Fewbytes Technologies, Inc."
maintainer_email "avishai@fewbytes.com"
license          "Apache 2.0"
description      "Installs/Configures redis"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
supports         "ubuntu", ">= 9.04"
supports         "debian", ">= 6.0"
supports         "centos", ">= 5.5"
supports         "redhat", ">= 5.5"

recipe           "redis", "Installs and configures redis"

attribute 'redis/source_url',
  :display_name => "Redis source URL",
  :default => "http://redis.googlecode.com/files/redis-2.2.2.tar.gz"
attribute "redis/build_dir",
  :display_name => "Redis build directory",
  :default => "/opt/redis/build"
attribute "redis/conf_dir",
  :display_name => "Redis configuration dir containing redis.conf",
  :default => "/etc/redis"
attribute "redis/log_dir",
  :display_name => "Directory used for log files",
  :default => "/var/log"
attribute "redis/instances/default/timeout",
  :display_name => "Timeout before connection close",
  :description => "Close the connection after a client is idle for N seconds (0 to disable)",
  :default => 300
attribute "redis/instances/default/dumpdb_filename",
  :display_name => "Database dump filename",
  :default => "dump.db"
attribute "redis/instances/default/data_dir",
  :display_name => "Directory for storing the database persistance files",
  :default => "/var/lib/redis"
attribute "redis/instances/default/activerehashing",
  :display_name => "Rehash redis table in memory",
  :description => "Active rehashing uses 1 millisecond every 100 milliseconds of CPU time in order to help rehashing the main Redis hash table (the one mapping top-level keys to values). The hash table implementation redis uses (see dict.c) performs a lazy rehashing: the more operations you run into an hash table that is rehashing, the more rehashing \"steps\" are performed, so if the server is idle the rehashing is never complete and some more memory is used by the hash table.takes about 1ms every 100ms",
  :default => "yes"
attribute "redis/instances/default/databases", 
  :display_name => "Number of Redis database",
  :default => 16
attribute "redis/instances/default/vm/enabled",
  :display_name => "Enable Redis swapping to disk",
  :default => "no"
attribute "redis/instances/default/vm/swap_file",
  :display_name => "Swap file location",
  :default => "/var/lib/redis/swap"
attribute "redis/instances/default/vm/max_memory",
  :display_name => "Maximum memory usage before swapping",
  :desription => "Configures the VM to use at max the specified amount of RAM. Everything that deos not fit will be swapped on disk *if* possible, that is, if there is still enough contiguous space in the swap file.",
  :default => "70% of total memory"
attribute "redis/instances/default/vm/page_size",
  :display_name => "Memory page size (bytes) in swap file",
  :description => "Redis swap files is split into pages. An object can be saved using multiple contiguous pages, but pages can't be shared between different objects. So if your page is too big, small objects swapped out on disk will waste a lot of space. If you page is too small, there is less space in the swap file (assuming you configured the same number of total swap file pages).",
  :default => 32 # bytes
attribute "redis/instances/default/vm/pages",
  :display_name => "Number of memory pages in the swap file",
  :description => "Number of total memory pages in the swap file. Given that the page table (a bitmap of free/used pages) is taken in memory, every 8 pages on disk will consume 1 byte of RAM. The total swap size is vm-page-size * vm-pages. With the default of 32-bytes memory pages and 134217728 pages Redis will use a 4 GB swap file, that will use 16 MB of RAM for the page table. It's better to use the smallest acceptable value for your application, but the default is large in order to work in most conditions.",
  :default => 134217728 
attribute "redis/instances/default/vm/max_threads",
  :display_name => "Number of VM IO threads",
  :default => 4
attribute "redis/instances/default/maxmemory",
  :display_name => "Maximum memory to use for redis",
  :default => "Unset"
attribute "redis/instances/default/maxmemory_samples",
  :display_name => "Sample size for eviction algorithms",
  :default => 3
attribute "redis/instances/default/maxmemory_policy",
  :display_name => "Memory eviction algorithm",
  :default => "volatile-lru"
attribute "redis/instances/default/appendonly",
  :display_name => "Write append log",
  :default => "no"
attribute "redis/instances/default/appendfsync",
  :display_name => "Call fsync after writing to append log",
  :default => "everysec"
attribute "redis/instances/default/no_appendfsync_on_rewrite",
  :display_name => "Don't use fsync on rewrites",
  :default => "no"
attribute "redis/instances/default/replication/master_role",
  :display_name => "Master Redis chef role"
