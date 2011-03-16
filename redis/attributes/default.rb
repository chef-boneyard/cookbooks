default[:redis][:timeout] = 300
default[:redis][:conf_dir] = "/etc/redis"
default[:redis][:log_dir] = "/var/log"
default[:redis][:dumpdb_filename] = "dump.db"
default[:redis][:data_dir] = "/var/lib/redis"
default[:redis][:activerehashing] = "yes" # no to disable, yes to enable
default[:redis][:databases] = 16

default[:redis][:appendonly] = "no"
default[:redis][:appendfsync] = "everysec"
default[:redis][:no_appendfsync_on_rewrite] = "no"

default[:redis][:vm][:enabled] = "no" # no to disable, yes to enable
default[:redis][:vm][:swap_file] = "/var/lib/redis/swap"
default[:redis][:vm][:max_memory] = node[:memory][:total].to_i * 1024 * 0.7
default[:redis][:vm][:page_size] = 32 # bytes
default[:redis][:vm][:pages] = 134217728 # swap file size is pages * page_size
default[:redis][:vm][:max_threads] = 4

default[:redis][:maxmemory_samples] = 3
default[:redis][:maxmemory_policy] = "volatile-lru"
