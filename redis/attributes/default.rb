default[:redis][:log_dir] =  "/var/log/redis"
default[:redis][:conf_dir] = "/etc/redis"
default[:redis][:user] =     "redis"
default[:redis][:instances][:default][:timeout] = 300
default[:redis][:instances][:default][:dumpdb_filename] = "dump.db"
default[:redis][:instances][:default][:data_dir] = "/var/lib/redis"
default[:redis][:instances][:default][:activerehashing] = "yes" # no to disable, yes to enable
default[:redis][:instances][:default][:databases] = 16

default[:redis][:instances][:default][:appendonly] = "no"
default[:redis][:instances][:default][:appendfsync] = "everysec"
default[:redis][:instances][:default][:no_appendfsync_on_rewrite] = "no"

default[:redis][:instances][:default][:vm][:enabled] = "no" # no to disable, yes to enable
default[:redis][:instances][:default][:vm][:swap_file] = "/var/lib/redis/swap"
default[:redis][:instances][:default][:vm][:max_memory] = node[:memory][:total].to_i * 1024 * 0.7
default[:redis][:instances][:default][:vm][:page_size] = 32 # bytes
default[:redis][:instances][:default][:vm][:pages] = 134217728 # swap file size is pages * page_size
default[:redis][:instances][:default][:vm][:max_threads] = 4

default[:redis][:instances][:default][:maxmemory_samples] = 3
default[:redis][:instances][:default][:maxmemory_policy] = "volatile-lru"
