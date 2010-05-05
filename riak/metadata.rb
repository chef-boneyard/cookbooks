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
attribute "riak",
  :display_name => "Riak",
  :description => "Riak is a Dynamo-inspired key/value store",
  :type => "hash"

attribute "riak/package",
  :type => "hash"
  
attribute "riak/package/type",
  :display_name => "Package type",
  :description => "Package type for installation (source or binary)",
  :default => "binary"

attribute "riak/package/version/major",
  :display_name => "Riak major version",
  :description => "Major version of Riak to install.",
  :default => "0"

attribute "riak/package/version/minor",
  :display_name => "Riak minor version",
  :description => "Minor version of Riak to install.",
  :default => "10"
     
attribute "riak/package/version/incremental",
  :display_name => "Riak incremental version",
  :description => "Incremental release of Riak to install.",
  :default => "1"
  
attribute "riak/package/prefix",
  :display_name => "Installation prefix",
  :description => "Installation prefix for source installs",
  :default => "/usr/local"

attribute "riak/limit_port_range",
  :display_name => "Limit port range",
  :description => "Boolean indicating whether to limit the range of ports used for Erlang node communication.",
  :default => "true"
  
attribute "riak/package/kernel/inet_dist_listen_min",
  :display_name => "Minimum port for Erlang node communication",
  :default => "6000"
  
attribute "riak/package/kernel/inet_dist_listen_max",
  :display_name => "Maximum port for Erlang node communication",
  :default => "7999"

#
# Erlang Configuration components
#
attribute "riak/erlang",
  :display_name => "Erlang configuration",
  :type => "hash"
        
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
  :default => "5"

attribute "riak/erlang/env_vars",
  :display_name => "Additional Erlang environment variables",
  :default => "[\"ERL_MAX_PORTS 4096\", \"ERL_FULLSWEEP_AFTER 10\"]"
  
#
# riak-core Configuration components
#
attribute "riak/core",
  :display_name => "Riak core",
  :description => "Riak core system configuration",
  :type => "hash"
      
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
  :default => "3"

attribute "riak/core/ring_state_dir",
  :display_name => "Ring state directory",
  :description => "The directory on-disk in which to store the ring state (default: data/ring)",
  :default => "/var/lib/riak/ring"
  
attribute "riak/core/ring_creation_size",
  :display_name => "Ring creation size",
  :description => "The number of partitions into which to divide the hash space (default: 64)",
  :default => "64"

attribute "riak/core/web_ip",
  :display_name => "HTTP address",
  :description => "The IP address on which Riak's HTTP interface should listen (default: 127.0.0.1)",
  :default => "127.0.0.1"

attribute "riak/core/web_port",
  :display_name => "HTTP port",
  :description => "The port on which Riak's HTTP interface should listen (default: 8098)",
  :default => "8098"

#
# riak-kv Configuration components
#
attribute "riak/kv",
  :display_name => "Riak key/value",
  :description => "Riak key/value system configuration",
  :type => "hash"

attribute "riak/kv/add_paths",
  :display_name => "Additional Erlang paths",
  :description => "A list of paths to add to the Erlang code path"

attribute "riak/kv/handoff_concurrency",
  :display_name => "Handoff concurrency",
  :description => "Number of vnode, per physical node, allowed to perform handoff at once."
 
attribute "riak/kv/js_vm_count",
  :default_name => "Javascript virtual machine count",
  :description => "How many Javascript virtual machines to start (default: 8)",
  :default => "8"

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
  :default => ""

attribute "riak/kv/pb_ip",
  :display_name => "Protocol Buffers Client (PBC) address",
  :description => "The IP address on which Riak's PBC interface should listen",
  :default => "127.0.0.1"

attribute "riak/kv/pb_port",
  :display_name => " Protocol Buffers Client (PBC) port",
  :description => "The port on which Riak's PBC interface should listen",
  :default => "8087"

attribute "riak/kv/handoff_port",
  :display_name => "Handoff port",
  :description => "TCP port number for the handoff listener (default: 8099)",
  :default => "8099"
    
attribute "riak/kv/storage_backend",
  :display_name => "Storage backend",
  :description => "The module name of the storage backend that Riak should use.",
  :default => "riak_kv_dets_backend"

attribute "riak/kv/storage_backend_options",
  :display_name => "Storage backend options",
  :description => "Additional configuration options for storage backends (varies by storage_backend)",
  :default => "hash"

#
# DETS Configuration components
#
# Only applicable if storage_backend is set to "riak_kv_dets_backend"
#
attribute "riak/kv/storage_backend_options/riak_kv_dets_backend_root",
  :display_name => "Data root directory",
  :description => "Directory where the data files will be stored.",
  :default => "/var/lib/riak/dets"  

#
# InnoDB Configuration components
#
# Only applicable if storage_backend is set to "innostore_riak"
#
attribute "riak/kv/storage_backend_options/buffer_pool_size",
  :display_name => "Buffer pool size",
  :description => "Size of the buffer pool in bytes.",
  :default => "2147483648"

attribute "riak/kv/storage_backend_options/data_home_dir",
  :display_name => "Data home directory",
  :description => "Directory where the system files will be created. All database directories will also be created relative to this path.  Note: The path must end in a / or \\ depending on the platform.",
  :default => "/var/lib/riak/innodb"  

attribute "riak/kv/storage_backend_options/log_group_home_dir",	
  :display_name => "Log file path",
  :description => "Path to the directory where the log files will be created.",
  :default => "/var/lib/riak/innodb"

attribute "riak/kv/storage_backend_options/log_buffer_size",	
  :display_name => "Log buffer size",
  :description => "Size of the in-memory log buffer in bytes.",
  :default => "8388608"

attribute "riak/kv/storage_backend_options/log_files_in_group",	
  :display_name => "Log files in group",
  :default => "8"

attribute "riak/kv/storage_backend_options/log_file_size",	
  :display_name => "Log file size",
  :description => "Log file size in bytes.",
  :default => "268435456"

attribute "riak/kv/storage_backend_options/flush_log_at_trx_commit",	
  :display_name => "Log flush policy",
  :description => "This variable can be set to 0, 1 or 2.\n
                   0 - Force sync of log contents to disk once every second.\n
                   1 - Force sync of log contents to disk at transaction commit.\n
                   2 - Write log contents to disk at transaction commit but do not force sync.\n",
  :default => "1"

#
# Bitcask Configuration components
#
# Only applicable if storage_backend is set to "riak_kv_bitcask_backend"
#
attribute "riak/kv/storage_backend_options/writes_per_fsync",
  :display_name => "Writes per fsync",
  :description => "Number of write operations before forcing an fsync.",
  :default => "1"

attribute "riak/kv/storage_backend_options/data_root",
  :display_name => "Data root directory",
  :description => "Directory where the data files will be stored.",
  :default => "/var/lib/riak/bitcask"
