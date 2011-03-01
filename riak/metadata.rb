#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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
description       "Installs and configures Riak distributed data store (v0.14 and later)"
version           "0.14.0"
recipe            "riak", "Installs Riak"
recipe            "riak::autoconf", "Automatically configure nodes from chef-server information."
recipe            "riak::innostore", "Install and configure the Innostore backend."
recipe            "riak::iptables", "Automatically configure iptables rules for Riak."
depends           "iptables"

%w{ubuntu debian}.each do |os|
  supports os
end
#
# Global Configuration components
#
grouping "riak",
  :title => "Riak",
  :description => "Riak is a Dynamo-inspired key/value store"

grouping "riak/package", :title => "Riak package options"
  
attribute "riak/package/type",
  :display_name => "Package type",
  :description => "Package type for installation (source or binary)",
  :default => "binary",
  :choice => ["binary", "source"]

attribute "riak/package/version/major",
  :display_name => "Riak major version",
  :description => "Major version of Riak to install.",
  :default => "0"

attribute "riak/package/version/minor",
  :display_name => "Riak minor version",
  :description => "Minor version of Riak to install.",
  :default => "14"
     
attribute "riak/package/version/incremental",
  :display_name => "Riak incremental version",
  :description => "Incremental release of Riak to install.",
  :default => "0"
  
attribute "riak/package/version/build",
  :display_name => "Riak binary package build version",
  :description => "For binary packages, the specific build to use.",
  :default => "1"
      
attribute "riak/package/prefix",
  :display_name => "Installation prefix",
  :description => "Installation prefix for source installs",
  :default => "/usr/local"

#
# Configuration for the "kernel" OTP app
#
grouping "riak/kernel", :title => "Riak-related Erlang kernel options"

attribute "riak/kernel/limit_port_range",
  :display_name => "Limit port range",
  :description => "Boolean indicating whether to limit the range of ports used for Erlang node communication.",
  :default => "true"
  
attribute "riak/kernel/inet_dist_listen_min",
  :display_name => "Minimum port for Erlang node communication",
  :default => "6000"
  
attribute "riak/kernel/inet_dist_listen_max",
  :display_name => "Maximum port for Erlang node communication",
  :default => "7999"

#
# Erlang Configuration components
#
grouping "riak/erlang", :title => "Erlang virtual machine configuration"
        
attribute "riak/erlang/node_name",
  :display_name => "Erlang node name",
  :description => "The name of the Erlang node",
  :default => "riak@127.0.0.1"

attribute "riak/erlang/cookie",
  :display_name => "Erlang cookie",
  :description => "The cookie of the Erlang node",
  :default => "riak"

attribute "riak/erlang/heart",
  :display_name => "Enable heart node monitoring",
  :default => "false"

attribute "riak/erlang/kernel_polling",
  :display_name => "Enable kernel polling",
  :default => "true"

attribute "riak/erlang/async_threads",
  :display_name => "Async thread pool size",
  :description => "Number of threads in the async thread pool",
  :default => "64"

grouping "riak/erlang/env_vars", :title => "Additional Erlang environment variables"

attribute "riak/erlang/env_vars/ERL_MAX_PORTS",
  :display_name => "The maximum number of ports Erlang can open",
  :default => "4096"

attribute "riak/erlang/env_vars/ERL_FULLSWEEP_AFTER",
  :display_name => "How often (in reductions) to run a fullsweep in the garbage collector",
  :default => "0"
  
#
# riak-core Configuration components
#
grouping "riak/core", :title => "Riak core", :description => "Riak core system configuration"
      
attribute "riak/core/cluster_name",
  :display_name => "Riak cluster name",
  :default => "default"

attribute "riak/core/default_bucket_props",
  :display_name => "Default bucket properties"
  
attribute "riak/core/gossip_interval",
  :display_name => "Gossip interval",
  :description => "Gossip interval in milliseconds",
  :default => "60000"
  
attribute "riak/core/target_n_val",
  :display_name => "Target N",
  :default => "4"

attribute "riak/core/ring_state_dir",
  :display_name => "Ring state directory",
  :description => "The directory on-disk in which to store the ring state (default: data/ring)",
  :default => "/var/lib/riak/ring"
  
attribute "riak/core/ring_creation_size",
  :display_name => "Ring creation size",
  :description => "The number of partitions into which to divide the hash space (default: 64)",
  :default => "64"

attribute "riak/core/http",
  :display_name => "HTTP interfaces",
:description => "The IP address / port pairs that Riak's HTTP interface will listen on. default: [[\"127.0.0.1\",8098]]",
:default => "[[\"127.0.0.1\",8098]]"

attribute "riak/core/https",
  :display_name => "HTTPS interfaces",
:description => "The IP address / port pairs that Riak's HTTPS (SSL) interface will listen on. default: empty"

attribute "riak/core/vnode_inactivity_timeout",
  :display_name => "VNode inactivity timeout",
  :description => "How often to check if fallback vnodes should return their data, in milliseconds.",
  :default => "60000"

attribute "riak/core/handoff_concurrency",
  :display_name => "Handoff concurrency",
  :description => "Number of vnodes, per physical node, allowed to perform handoff at once. (default: 4)",
  :default => "4"

attribute "riak/core/handoff_port",
  :display_name => "Handoff port",
  :description => "TCP port number for the handoff listener (default: 8099)",
  :default => "8099"

attribute "riak/core/disable_http_nagle",
  :display_name => "Disable HTTP Nagle",
  :description => "Disable Nagle's algorithm on HTTP sockets",
  :default => "false"

#
# riak-kv Configuration components
#
grouping "riak/kv", :title => "Riak key/value",
  :description => "Riak key/value system configuration"

attribute "riak/kv/add_paths",
  :display_name => "Additional Erlang paths",
  :description => "A list of paths to add to the Erlang code path"

attribute "riak/kv/mapred_queue_dir",
  :display_name => "MapReduce queue directory",
  :description => "Directory used to store a transient queue for pending map tasks. (default: /var/lib/riak/mr_queue)",
  :default => "/var/lib/riak/mr_queue"

attribute "riak/kv/mapper_batch_size",
  :display_name => "Mapper batch size",
  :description => "Number of items the mapper will fetch in one request. Larger values can impact read/write performance for non-MapReduce requests. (default: 5)",
  :default => "5"


attribute "riak/kv/map_js_vm_count",
  :display_name => "JS VMs for map functions",
  :description => "How many Javascript virtual machies are available for map functions. (default: 8)",
  :default => "8"

attribute "riak/kv/reduce_js_vm_count",
  :display_name => "JS VMs for reduce functions",
  :description => "How many Javascript virtual machies are available for reduce functions. (default: 6)",
  :default => "6"

attribute "riak/kv/hook_js_vm_count",
  :display_name => "JS VMs for hook functions",
  :description => "How many Javascript virtual machies are available for pre-commit functions. (default: 2)",
  :default => "2"

attribute "riak/kv/js_max_vm_mem",
  :default_name => "Maximum JS VM memory",
  :description => "the maximum amount of memory, in megabytes, allocated to the Javascript VMs (default: 8)",
  :default => "8"

attribute "riak/kv/js_thread_stack",
  :default_name => "Maximum JS VM thread stack",
  :description => "The maximum amount of thread stack, in megabytes, allocated to the Javascript VMs (default: 16)",
  :default => "16"

attribute "riak/kv/js_source_dir",
  :default_name => "Javascript source directory",
  :description => "Where to load user-defined built in Javascript functions"

attribute "riak/kv/mapred_name",
  :display_name => "Map/Reduce base path",
  :description => "The base of the path in the URL exposing Riak's Map/Reduce interface",
  :default => "mapred"

attribute "riak/kv/raw_name",
  :display_name => "HTTP base path",
  :description => "The base of the path in the URL exposing Riak's HTTP interface.",
  :default => "riak"

attribute "riak/kv/riak_kv_stat",
  :display_name => "Statistics reporting",
  :description => "Enables the statistics-aggregator if set to true.",
  :default => "true"

attribute "riak/kv/stats_urlpath",
  :display_name => "Path for HTTP retrieval of statistics",
  :default => "stats"

attribute "riak/kv/pb_ip",
  :display_name => "Protocol Buffers Client (PBC) address",
  :description => "The IP address on which Riak's PBC interface should listen",
  :default => "127.0.0.1"

attribute "riak/kv/pb_port",
  :display_name => " Protocol Buffers Client (PBC) port",
  :description => "The port on which Riak's PBC interface should listen",
  :default => "8087"
    
attribute "riak/kv/storage_backend",
  :display_name => "Storage backend",
  :description => "The module name of the storage backend that Riak should use.",
  :default => "riak_kv_bitcask_backend"

#
# DETS Configuration components
#
# Only applicable if storage_backend is set to "riak_kv_dets_backend"
#
attribute "riak/kv/riak_kv_dets_backend_root",
  :display_name => "Data root directory",
  :description => "Directory where the data files will be stored.",
  :default => "/var/lib/riak/dets"  

#
# InnoDB Configuration components
#
# Only applicable if storage_backend is set to "riak_kv_innostore_backend"
#
grouping "riak/innostore", :title => "Innostore (Embedded InnoDB) configuration"

attribute "riak/innostore/version", :title => "Innostore version", :default => "1.0.3"

attribute "riak/innostore/build", :title => "Innostore package build", :default => "1"

attribute "riak/innostore/buffer_pool_size",
  :display_name => "Buffer pool size",
  :description => "Size of the buffer pool in bytes.",
  :default => "2147483648"

attribute "riak/innostore/data_home_dir",
  :display_name => "Data home directory",
  :description => "Directory where the system files will be created. All database directories will also be created relative to this path.  Note: The path must end in a / or \\ depending on the platform.",
  :default => "/var/lib/riak/innodb"  

attribute "riak/innostore/log_group_home_dir",	
  :display_name => "Log file path",
  :description => "Path to the directory where the log files will be created.",
  :default => "/var/lib/riak/innodb"

attribute "riak/innostore/log_buffer_size",	
  :display_name => "Log buffer size",
  :description => "Size of the in-memory log buffer in bytes.",
  :default => "8388608"

attribute "riak/innostore/log_files_in_group",	
  :display_name => "Log files in group",
  :default => "8"

attribute "riak/innostore/log_file_size",	
  :display_name => "Log file size",
  :description => "Log file size in bytes.",
  :default => "268435456"

attribute "riak/innostore/flush_log_at_trx_commit",	
  :display_name => "Log flush policy",
  :description => "This variable can be set to 0, 1 or 2.\n
                   0 - Force sync of log contents to disk once every second.\n
                   1 - Force sync of log contents to disk at transaction commit.\n
                   2 - Write log contents to disk at transaction commit but do not force sync.\n",
  :default => "1"

attribute "riak/innostore/flush_method",
  :display_name => "Method for flushing writes to disk",
  :description => "Modifies the way Innostore writes to disk",
  :default => "fdatasync",
  :choice => %w[fdatasync O_DSYNC O_DIRECT async_unbuffered]

#
# Bitcask Configuration components
#
# Only applicable if storage_backend is set to "riak_kv_bitcask_backend"
#
grouping "riak/bitcask", :title => "Bitcask log-structured storage engine configuration"

attribute "riak/bitcask/data_root",
  :display_name => "Data root directory",
  :description => "Directory where the data files will be stored.",
  :default => "/var/lib/riak/bitcask"

attribute "riak/bitcask/max_file_size",
  :display_name => "Maximum file size",
  :description => "Maximum size for a single Bitcask cask file.",
  :default => "2147483648"
  
# * none          - let the O/S decide
# * o_sync        - use the O_SYNC flag to sync each write
# * {seconds, N}  - call bitcask:sync/1 every N seconds
attribute "riak/bitcask/sync_strategy",
  :display_name => "Sync strategy",
  :description => "Sync strategy is one of: :none (let the OS decide), :o_sync, or {:seconds => N} (which requires application support)",
  :default => "none"
  
# Merge trigger variables. Files exceeding ANY of these
# values will cause bitcask:needs_merge/1 to return true.
attribute "riak/bitcask/frag_merge_trigger",
  :display_name => "Fragment merge trigger",
  :default => "60"
  
attribute "riak/bitcask/dead_bytes_merge_trigger",
  :display_name => "Dead bytes merge trigger",
  :default => "536870912"
  
# Merge thresholds. Files exceeding ANY of these values
# will be included in the list of files marked for merging
# by bitcask:needs_merge/1.
attribute "riak/bitcask/frag_threshold",
  :display_name => "Fragment threshold",
  :default => "40"
  
attribute "riak/bitcask/dead_bytes_threshold",
  :display_name => "Dead bytes threshold",
  :default => "134217728"
  
attribute "riak/bitcask/small_file_threshold",
  :display_name => "Small file threshold",
  :default => "10485760"
  
attribute "riak/bitcask/expiry_secs",
  :display_name => "Data expiration threshold, in seconds",
  :description => "Data expiration can be caused by setting this to a positive value.  If set, items older than the value will be discarded.",
  :default => "-1"

#
# Error reporting components
#
grouping "riak/err", :title => "Riak error reporting configuration"

attribute "riak/err/term_max_size",
  :display_name => "Maximum error term size.",
  :description => "Info/error/warning reports larger than this will be considered too big to be formatted safely with the user-supplied format string.",
  :default => "65536"

attribute "riak/err/fmt_max_bytes",
  :display_name => "Maximum total size of info/error/warning reports.",
  :description => "Limit the total size of formatted info/error/warning reports.",
  :default => "65536"

#
# Luwak component
#
grouping "riak/luwak", :title => "Luwak large-object interface configuration"
attribute "riak/luwak/enabled", :display_name => "Enable luwak", :default => "false"
