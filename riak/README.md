Riak Cookbook
=============

Overview
========

Riak is a Dynamo-inspired key/value store that scales predictably and easily.  Riak combines a decentralized key/value store, a flexible map/reduce engine, and a friendly HTTP/JSON query interface to provide a database ideally suited for Web applications. And, without any object-relational mappers and other heavy middleware, applications built on Riak can be both simpler and more powerful.  For complete documentation and source code, see the Riak home page at [Basho][1].


Getting Started
===============

The Riak cookbook can be used just by adding "riak" to the runlist for a node.  The default settings will cause Riak to be installed and configured.  Creating a cluster of nodes requires you set appropriate attributes, particularly the Erlang `node_name`, and either manually join nodes to the cluster or use the gossip seed configuration option.


Package Installation
--------------------

There are two options for package installation: source and binary.  If you are using a RedHat or Debian/Ubuntu system, binary installation is recommended and is the default.  If you choose to do a source installation, be sure you are using Erlang/OTP R13B04 or later.

The package parameters available are version, type and, optionally for source installation, an install prefix:

	node[:riak][:package][:version][:major] = "0"
	node[:riak][:package][:version][:minor] = "10"
	node[:riak][:package][:version][:incremental] = "1"
	node[:riak][:package][:type] = ("binary" | "source")
	node[:riak][:package][:prefix] = "/usr/local"


Basic Configuration
-------------------

Most Riak configuration is for networking, Erlang, and storage backends.  The only, interesting configuration options outside of those is the filesystem path where ring state files should be stored.

	node[:riak][:core][:ring_state_dir] = "/var/lib/riak/ring"


Networking
----------

Riak clients communicate with the nodes in the cluster through either the HTTP or Protobufs interfaces, both of which may be used simultaneously.  Configuration for each interface includes the IP address and TCP port on which to listen for client connections.  The default for the HTTP interface, web ip, is localhost:8098 and for Protobufs 0.0.0.0:8087, meaning client connections to any address on the server, TCP port 8087, are accepted.  As the default `web_ip` is inaccessible to other nodes, it must be changed if you want clients to use the HTTP interface.

	node[:riak][:core][:web_ip] = "127.0.0.1"
	node[:riak][:core][:web_port] = 8098
	node[:riak][:kv][:pb_ip] = "0.0.0.0"
	node[:riak][:kv][:pb_port] = 8087

Intra-cluster handoff occurs over a dedicated port, which defaults to 8099.

	node[:riak][:kv][:handoff_port] = 8099

Finally, by default, options are included in the configuration to define the set of ports used for Erlang inter-node communication.  

	node[:riak][:limit_port_range] = true
	node[:riak][:kernel][:inet_dist_listen_min] = 6000
	node[:riak][:kernel][:inet_dist_listen_max] = 7999

On Debian/Ubuntu platforms, IPTables rules corresponding to these settings to explicitly allow required ports and addresses are automatically generated.


Erlang
------

A number of Erlang parameters may be configured through the cookbook.  The node name and cookie are most important for creating multi-node clusters.  The rest of the parameters are primarily for performance tuning, with kernel polling and smp enabled by default.  Any available Erlang environment variable may be set with the env vars array. 

	node[:riak][:erlang][:node_name] = "riak@#{node[:riak][:core][:web_ip]}"
	node[:riak][:erlang][:cookie] = "riak"
	node[:riak][:erlang][:kernel_polling] = (true | false)
	node[:riak][:erlang][:async_threads] = 5
	node[:riak][:erlang][:smp] = ("enable" | "disable")
	node[:riak][:erlang][:env_vars] = ["ERL_MAX_PORTS 4096", "ERL_FULLSWEEP_AFTER 10"]


Storage Backends
================

Riak requires specification of a storage backend along with various backend storage options, specific to each backend.  While Riak supports specification of different backends for different buckets, the Chef cookbook does not yet allow such configurations.  The most common backends are DETS (the default), Innostore, and Bitcask.  The typical configuration options and their defaults are given below.


DETS
----

DETS is the default storage backend for Riak.  It's very simple to setup, only requiring a path where it should store data files.  However, for production use Innostore and Bitcask are better choices.

	node[:riak][:kv][:storage_backend_options][:riak_kv_dets_backend_root] = "/var/lib/riak/dets"


Innostore
---------

Innostore is an Erlang wrapper around embedded InnoDB, a transactional storage engine developed for and generally used with MySQL.  It has an enormous set of tuning parameters, all of which are documented at the [InnoDB site][2].  The most common parameters are set to reasonable defaults by the Riak cookbook.

	node[:riak][:kv][:storage_backend_options][:log_buffer_size] = 8388608
	node[:riak][:kv][:storage_backend_options][:log_files_in_group] = 8
	node[:riak][:kv][:storage_backend_options][:log_file_size] = 268435456
	node[:riak][:kv][:storage_backend_options][:flush_log_at_trx_commit] = 1
	node[:riak][:kv][:storage_backend_options][:data_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:kv][:storage_backend_options][:log_group_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:kv][:storage_backend_options][:buffer_pool_size] = 2147483648


Bitcask
-------

By virtue of its architecture, Bitcask requires much less tuning to achieve good performance than Innostore.  The default value for `writes_per_fsync` of 1 makes Bitcask call fsync() after every write.  This is the safest choice, though not always the best performing.

	node[:riak][:kv][:storage_backend_options][:writes_per_fsync] = 1
	node[:riak][:kv][:storage_backend_options][:data_root] = "/var/lib/riak/bitcask"  


[1]: http://basho.com/
[2]: http://www.innodb.com/doc/embedded_innodb-1.0/#config-vars
