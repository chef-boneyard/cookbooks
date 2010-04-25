#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: riak
# Recipe:: inno
#
# Copyright (c) 2010 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

maintainer        "Basho Technologies, Inc."
maintainer_email  "riak@basho.com"
license           "Apache 2.0"
description       "Installs and configures Riak distributed data store (v0.10 and later)"
version           "0.1"
recipe            "riak::autoconf", "Automatically configure nodes from chef-server information."
recipe            "riak::innostore", "Install and configure the Innostore backend."
recipe            "riak::iptables", "Automatically configure iptables rules for Riak."
depends           "erlang"
depends           "mercurial"

%w{ubuntu debian}.each do |os|
  supports os
  depends           "iptables"
end

#
# Global Configuration components
#
attribute "riak"
  :display_name => "Riak",
  :description => "Riak is a Dynamo-inspired key/value store",
  :type => "hash"

attribute "riak/package"
  :type => "hash"
  
attribute "riak/package/type"
  :default => "binary"
  
#
# erlang Configuration components
#
attribute "riak/erlang"
  :display_name => "Erlang configuration",
  :type => "hash"
        
attribute "riak/erlang/node_name"
  :display_name => "Erlang node name",
  :description => "The name of the Erlang node",
  :default => "riak@127.0.0.1"

attribute "riak/erlang/cookie"
  :display_name => "Erlang cookie",
  :description => "The cookie of the Erlang node",
  :default => "riak"

attribute "riak/erlang/heart"
  :display_name => "Enable heart node monitoring",
  :default => "false"

attribute "riak/erlang/kernel_polling"
  :display_name => "Enable kernel polling",
  :default => "true"

attribute "riak/erlang/async_threads"
  :display_name => "Async thread pool size",
  :description => "Number of threads in the async thread pool",
  :default => "5"

attribute "riak/erlang/env_vars"
  :display_name => "Additional Erlang environment variables"
  
#
# riak-core Configuration components
#
attribute "riak/core"
  :display_name => "Riak core",
  :description => "Riak core system configuration",
  :type => "hash"
      
attribute "riak/core/cluster_name"
  :display_name => "Riak cluster name",
  :default => "default"

attribute "riak/core/default_bucket_props"
  :display_name => "Default bucket properties"
  
attribute "riak/core/gossip_interval"
  :display_name => "Gossip interval",
  :description => "Gossip interval in milliseconds"
  :default => "60000"
  
attribute "riak/core/target_n_val"
  :display_name => "Target N",
  :default => "3"
  
attribute "riak/core/wants_claim_fun"
  :display_name => "Wants claim function"

attribute "riak/core/ring_state_dir"
  :display_name => "Ring state directory",
  :description => "The directory on-disk in which to store the ring state (default: data/ring)",
  :default => "/var/lib/riak/ring"
  
attribute "riak/core/ring_creation_size"
  :display_name => "Ring creation size",
  :description => "The number of partitions into which to divide the hash space (default: 64)",
  :default => "64"

attribute "riak/core/web_ip"
  :display_name => "HTTP address",
  :description => "The IP address on which Riak's HTTP interface should listen (default: 127.0.0.1)",
  :default => "127.0.0.1"

attribute "riak/core/web_port"
  :display_name => "HTTP port",
  :description => "The port on which Riak's HTTP interface should listen (default: 8098)",
  :default => "8098"

attribute "riak/core/web_logdir"
  :display_name => "HTTP log directory",
  :default => "log"

#
# riak-kv Configuration components
#
attribute "riak/kv"
  :display_name => "Riak key/value",
  :description => "Riak key/value system configuration",
  :type => "hash"

attribute "riak/kv/add_paths"
  :display_name => "Additional Erlang paths",
  :description => "A list of paths to add to the Erlang code path"

attribute "riak/kv/handoff_concurrency"
  :display_name => "Handoff concurrency",
  :description => "Number of vnode, per physical node, allowed to perform handoff at once."
 
attribute "riak/kv/js_vm_count"
  :default_name => "Javascript virtual machine count",
  :description => "How many Javascript virtual machines to start (default: 8)",
  :default => "8"

attribute "riak/kv/js_source_dir"
  :default_name => "Javascript source directory",
  :description => "Where to load user-defined built in Javascript functions"

attribute "riak/kv/mapred_name"
  :display_name => "Map/Reduce name",
  :description => "",
  :default => ""

attribute "riak/kv/raw_name"
  :display_name => "HTTP base path",
  :description => "The base of the path in the URL exposing Riak's HTTP interface (default: riak)",
  :default => "riak"

attribute "riak/kv/riak_kv_stat"
  :display_name => "Statistics reporting",
  :description => "Enables the statistics-aggregator if set to true.",
  :default => "true"

attribute "riak/kv/stats_urlpath"
  :display_name => "Path for HTTP retrieval of statistics",
  :default => ""

attribute "riak/kv/pb_ip"
  :display_name => "Protocol Buffers Client (PBC) address",
  :description => "The IP address on which Riak's PBC interface should listen",
  :default => "127.0.0.1"

attribute "riak/kv/pb_port"
  :display_name => " Protocol Buffers Client (PBC) port",
  :description => "The port on which Riak's PBC interface should listen",
  :default => "8087"

attribute "riak/kv/handoff_port"
  :display_name => "Handoff port",
  :description => "TCP port number for the handoff listener (default: 8099)",
  :default => "8099"
    
attribute "riak/kv/storage_backend"
  :display_name => "Storage backend",
  :description => "The module name of the storage backend that Riak should use (default: riak_kv_dets_backend)",
  :default => "riak_kv_dets_backend"

attribute "riak/kv/storage_backend_options"
  :display_name => "Storage backend options",
  :description => "Additional configuration options for storage backends (varies by storage_backend)"
  :default => "hash"
  
#Available backends, and their additional configuration options are:

#riak_dets_backend: data is stored in DETS files
#riak_dets_backend_root: root directory where the DETS files are stored (default: "data/dets")
#riak_ets_backend: data is stored in ETS tables (in-memory)
#riak_gb_trees_backend: data is stored in general balanced trees (in-memory)
#riak_fs_backend: data is stored in binary files on the filesystem
#riak_fs_backendroot: root directory where the files are stored (ex: "/var/lib/riak/data")
#riak_multi_backend: enables storing data for different buckets in different backends
#Specify the backend to use for a bucket with riak_client:set_bucket(BucketName,[{backend, BackendName}] in Erlang or {"props":{"backend":"BackendName"}} in the REST API.
#multi_backend_default: default backend to use if none is specified for a bucket (one of the BackendName atoms specified in the multi_backend setting)
#multi_backend: list of backends to provide
#Format of each backend specification is {BackendName, BackendModule, BackendConfig}, where BackendName is any atom, BackendModule is the name of the Erlang module implementing the backend (the same values you would provide as storage_backend settings), and BackendConfig is a parameter that will be passed to the start/2 function of the backend module.
#riak_cache_backend: a backend that behaves as an LRU-with-timed-expiry cache
#riak_cache_backend_memory: maximum amount of memory to allocate, in megabytes (default: 100)
#riak_cache_backend_ttl: amount by which to extend an object's expiry lease on each access, in seconds (default: 600)
#riak_cache_backend_max_ttl: maximum allowed lease time (default: 3600)

#
# InnoDB Configuration components
#

#  {storage_backend, innostore_riak}

#* You may wish to also tune the innostore engine. Add a innostore
#  application section to the riak/etc/app.config:

#  %% Inno db config
#  {innostore, [
#               {data_home_dir,            "/mnt/innodb"},
#               {log_group_home_dir,       "/mnt/innodb"},
#               {buffer_pool_size,         2147483648} %% 2G of buffer
#              ]}

# adaptive_hash_index	Boolean	Pre-Startup	
# Set to OFF to disable the Adaptive Hash Index. Default is ON.

# adaptive_flushing	Boolean	Pre-Startup	
# Set to OFF to disable the adaptive flushing. Default is ON.

# additional_mem_pool_size	Integer	Pre-Startup	
# Embedded InnoDB uses a separate memory pool for house keeping and its data dictionary. The default setting is 4MB. If Embedded InnoDB needs more memory it will allocate using malloc().

# autoextend_increment	Integer	Pre-Startup	
# Embedded InnoDB will extend the tablespace by this many pages when it needs to increase the size of the table space. The default setting is 8 pages.

description "riak/kv/storage_backend_options/buffer_pool_size"
  :display_name => "Buffer pool size",
  :description => "Size of the buffer pool in megabytes.",
  :default => "8"

# checksums	Boolean	Pre-Startup	
# Set to OFF if you want to disable page checksums. Default is ON.

# data_file_path	Text	Pre-Startup	
# The names and sizes of the Embedded InnoDB tablespaces. The syntax for this variable in pseudo-BNF:
#
# size := INTEGER
# spec := filename:size[K|M|G]
# spec := spec[;spec]
# spec := spec[:autoextend[:max:size[K|M|G]]]
# An example:
# ibdata1:1G;ibdata2:64M:autoextend
#
# Note that a Windows path may contain a drive name and a ':' e.g.,
# C:\ibdata\ibdata1:1G

description "riak/kv/storage_backend_options/data_home_dir"
  :display_name => "Data home directory",
  :description => "Directory where the system files will be created. All database directories will also be created relative to this path.  Note: The path must end in a / or \\ depending on the platform.",
  :default => "./"
  
# doublewrite	Boolean	Pre-Startup	
# Controls whether InnoDB will use the double write buffer. Default is ON

# file_format	Text	Anytime	
# The highest format that InnoDB supports. This value is stamped on the InnoDB system tablespace.

# file_io_threads	Integer	Pre-Startup	
# The number of IO threads that Embedded InnoDB will create for IO operations. The default setting is 4 threads.

# file_per_table	Boolean	Pre-Startup	
# Controls whether InnoDB will store user tables in one table space or create a .ibd file per table. Default is ON.

# flush_log_at_trx_commit	Integer	Pre-Startup	
# This variable can be set to 0, 1 or 2.
# 0 - Force sync of log contents to disk once every second.
# 1 - Force sync of log contents to disk at transaction commit.
# 2 - Write log contents to disk at transaction commit but do not force sync.
# Default setting is 1.

# flush_method	Text	Pre-Startup	
# Permitted values are: fsync, O_DIRECT or O_DSYNC on Unices. On Windows there is only one possible setting: async_unbuffered.
# fsync - Open files without any special modes and use fsync() to sync all files.
# O_DIRECT - Open files using O_DIRECT on Solaris Embedded InnoDB will use directio(). All files are synced using fsync().
# O_DSYNC - Open only the log files using O_SYNC mode, data files are synced using fsync().
# The default setting on Unices is: fsync.

# force_recovery	Integer	Pre-Startup	
# Permitted values are 1, 2, 3, 4, 5 or 6.
# 1 - Force recovery of tables that have corrupt pages. Use this option to dump tables that have some pages that are corrupt by attempting to skip the corrupt pages.
# 2 - Disable the master thread, this will disable the purge operation.
# 3 - Do not rollback incomplete transactions during recovery
# 4 - Disable insert buffer merge.
# 5 - Disable read of UNDO logs, uncommitted transactions are treated as commited.
# 6 - Disable the redo log application during recovery

# io_capacity	Integer	Pre-Startup	
# The number of IO operations that the server can do. The default value is 200, the minimum permissible is 100. You can set this to a higher value if your hardware can handle higer IOPS.

# lock_wait_timeout	Integer	Pre-Startup	
# The time in seconds a transaction will wait for a lock. The default valus is 60 seconds.

# log_buffer_size	Integer	Pre-Startup	
# The size of the buffer for storing redo log entries. The default value is 384KB.

# log_file_size	Integer	Pre-Startup	
# Size of the REDO log files in mega bytes. Default is 16MB.

# log_files_in_group	Integer	Pre-Startup	
# The number of log files in a group. Embedded InnoDB writes to the log files in a circular fashion. Default value is 2.

attribute "riak/kv/storage_backend_options/log_group_home_dir"	
  :display_name => "Log file path",
  :description => "Path to the directory where the log files will be created.",
  :default => "./"

# max_dirty_pages_pct	Integer	Pre-Startup	
# The master thread tries to keep the ratio of modified pages in the buffer pool to all database pages in the buffer pool smaller than this number. But it is not guaranteed that the value stays below that during a time of heavy update/insert activity. The default value is 75.

# max_purge_lag	Integer	Pre-Startup	
# For controlling the delay of DML statements if purge is lagging. The default value is 0 (infinite).

# lru_old_blocks_pct	Integer	Anytime	
# This parameter is for the advanced user, change from the default setting only if you know what you are doing. It sets the point in the LRU list from where all pages are classified as "old". It is expressed as a percent. Default value is 37.

# lru_block_access_recency	Integer	Anytime	
# This parameter is for the advanced user, change from the default setting only if you know what you are doing. It sets the threshold in milliseconds between accesses to a block at which it will be made "young". The default value is 0 (disabled).

# open_files	Integer	Pre-Startup	
# If you have set “file_per_table” to ON, then this is useful in setting the number of file descriptors that Embedded InnoDB will keep open. Default value is 300.

# read_io_threads	Integer	Pre-Startup	
# Number of IO threads dedicated to reading. Default value is 4 threads

# write_io_threads	Integer	Pre-Startup	
# Number of IO threads dedicated to writing. Default value is 4 threads

# pre_rollback_hook	Callback	Disabled	
# Future use.

# print_verbose_log	Boolean	Pre-Startup	
# Disable if you want Embedded InnoDB to reduce the number of messages it writes to the logger. Default is ON.

# rollback_on_timeout	Integer	Pre-Startup	
# If set then we rollback the transaction on DB_LOCK_WAIT_TIMEOUT error. Default is ON

# status_file	Text	Anytime	
# Enable this if you want Embedded InnoDB to write the output of the status monitor to the logger. Default is OFF.

# sync_spin_loops	Integer	Pre-Startup	
# The number of times to spin while waiting for a latch. Default value is 30.

# use_sys_malloc	Boolean	Pre-Startup	
# Enable if you want Embedded InnoDB to use the system malloc() and free(). Default is OFF.
