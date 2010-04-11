maintainer        "Benjamin Black"
maintainer_email  "b@b3k.us"
license           "Apache 2.0"
description       "Installs and configures the Cassandra distributed storage system"
version           "0.1"
recipe            "cassandra::autoconf", "Automatically configure nodes from chef-server information."
recipe            "cassandra::ec2snitch", "Automatically configure properties snitch for clusters on EC2."
recipe            "cassandra::iptables", "Automatically configure iptables rules for cassandra."
depends           "java"
depends           "runit"

%w{ubuntu debian}.each do |os|
  supports os
  depends           "iptables"
end

attribute "cassandra",
  :display_name => "Cassandra",
  :description => "Hash of Cassandra attributes",
  :type => "hash"

attribute "cassandra/cluster_name",
  :display_name => "Cassandra cluster name",
  :description => "The name for the Cassandra cluster in which this node should participate.  The default is 'Test Cluster'.",
  :default => "Test Cluster"

attribute "cassandra/auto_bootstrap",
  :display_name => "Cassandra automatic boostrap boolean",
  :description => "Boolean indicating whether a node should automatically boostrap on startup.",
  :default => "false"
  
attribute "cassandra/keyspaces",
  :display_name => "Cassandra keyspaces",
  :description => "Hash of keyspace definitions.",
  :type => "array"
  
attribute "cassandra/authenticator",
  :display_name => "Cassandra authenticator",
  :description => "The IAuthenticator to be used for access control.",
  :default => "org.apache.cassandra.auth.AllowAllAuthenticator"

attribute "cassandra/partitioner",
  :display_name => "",
  :description => "",
  :default => "org.apache.cassandra.dht.RandomPartitioner"
  
attribute "cassandra/initial_token",
  :display_name => "",
  :description => "",
  :default => ""
  
attribute "cassandra/commit_log_dir",
  :display_name => "",
  :description => "",
  :default => "/var/lib/cassandra/commitlog"

attribute "cassandra/data_file_dirs",
  :display_name => "",
  :description => "",
  :default => ["/var/lib/cassandra/data"]
  
attribute "cassandra/callout_location",
  :display_name => "",
  :description => "",
  :default => "/var/lib/cassandra/callouts"
  
attribute "cassandra/staging_file_dir",
  :display_name => "",
  :description => "",
  :default => "/var/lib/cassandra/staging"
  
attribute "cassandra/seeds",
  :display_name => "",
  :description => "",
  :default => ["127.0.0.1"]
  
attribute "cassandra/rpc_timeout",
  :display_name => "",
  :description => "",
  :default => "5000"
  
attribute "cassandra/commit_log_rotation_threshold",
  :display_name => "",
  :description => "",
  :default => "128"
  
attribute "cassandra/listen_addr",
  :display_name => "",
  :description => "",
  :default => "localhost"
  
attribute "cassandra/storage_port",
  :display_name => "",
  :description => "",
  :default => "7000"

attribute "cassandra/thrift_addr",
  :display_name => "",
  :description => "",
  :default => "localhost"

attribute "cassandra/thrift_port",
  :display_name => "",
  :description => "",
  :default => "9160"

attribute "cassandra/thrift_framed_transport",
  :display_name => "",
  :description => "",
  :default => "false"
  
attribute "cassandra/disk_access_mode",
  :display_name => "",
  :description => "",
  :default => "auto"
  
attribute "cassandra/sliced_buffer_size",
  :display_name => "",
  :description => "",
  :default => "64"
  
attribute "cassandra/flush_data_buffer_size",
  :display_name => "",
  :description => "",
  :default => "32"
  
attribute "cassandra/flush_index_buffer_size",
  :display_name => "",
  :description => "",
  :default => "8"

attribute "cassandra/column_index_size",
  :display_name => "",
  :description => "",
  :default => "64"
  
attribute "cassandra/memtable_throughput",
  :display_name => "",
  :description => "",
  :default => "64"
  
attribute "cassandra/binary_memtable_throughput",
  :display_name => "",
  :description => "",
  :default => "256"
  
attribute "cassandra/memtable_ops",
  :display_name => "",
  :description => "",
  :default => "0.3"
  
attribute "cassandra/memtable_flush_after",
  :display_name => "",
  :description => "",
  :default => "60"
  
attribute "cassandra/concurrent_reads",
  :display_name => "",
  :description => "",
  :default => "8"
  
attribute "cassandra/concurrent_writes",
  :display_name => "",
  :description => "",
  :default => "32"
  
attribute "cassandra/commit_log_sync",
  :display_name => "",
  :description => "",
  :default => "periodic"
  
attribute "cassandra/commit_log_sync_period",
  :display_name => "",
  :description => "",
  :default => "10000"
  
attribute "cassandra/gc_grace",
  :display_name => "",
  :description => "",
  :default => "864000"
  
attribute "cassandra/public_access",
  :display_name => "Public access",
  :description => "If the node is on a cloud server with public and private IP addresses and public_access is true, then Thrift will be bound on the public IP address.  Disabled by default."
