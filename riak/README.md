Riak Cookbook
=============

Overview
========


Getting Started
===============


Package Installation
--------------------

There are two options for package installation: source and binary.  If you are using a RedHat or Debian/Ubuntu system, binary installation is recommended and is the default.  If you choose to do a source installation, be sure you are using Erlang/OTP R13B04 or later.

The package parameters available are version, type and, optionally for source installation, an install prefix:

	node[:riak][:package][:riak_version] = "0.10"
	node[:riak][:package][:riak_version_increment] = ".1"
	node[:riak][:package][:type] = ("binary" | "source")
	node[:riak][:package][:prefix] = "/usr/local"


Basic Configuration
-------------------

Most Riak configuration is for networking, Erlang, and storage backends.  The only, interesting configuration options outside of those is the filesystem path where ring state files should be stored.

	node[:riak][:core][:ring_state_dir] = "/var/lib/riak/ring"


Networking
----------

	node[:riak][:core][:web_ip] = "127.0.0.1"
	node[:riak][:core][:web_port] = 8098
	node[:riak][:kv][:pb_ip] = "0.0.0.0"
	node[:riak][:kv][:pb_port] = 8087
	node[:riak][:kv][:handoff_port] = 8099
	node[:riak][:limit_port_range] = true
	node[:riak][:kernel][:inet_dist_listen_min] = 6000
	node[:riak][:kernel][:inet_dist_listen_max] = 7999


Erlang
------

	node[:riak][:erlang][:node_name] = "riak@#{node[:riak][:core][:web_ip]}"
	node[:riak][:erlang][:cookie] = "riak"
	node[:riak][:erlang][:kernel_polling] = true
	node[:riak][:erlang][:async_threads] = 5
	node[:riak][:erlang][:smp] = "enable"
	node[:riak][:erlang][:env_vars] = ["ERL_MAX_PORTS 4096", "ERL_FULLSWEEP_AFTER 10"]


Storage Backends
================

Riak requires specification of a storage backend along with various backend storage options, specific to each backend.  While Riak supports specification of different backends for different buckets, the Chef cookbook does not yet allow such configurations.  The most common backends are DETS (the default), Innostore, and Bitcask.  The typical configuration options and their defaults are given below.

DETS
----

	node[:riak][:kv][:storage_backend_options][:riak_kv_dets_backend_root] = "/var/lib/riak/dets"


Innostore
---------

	node[:riak][:kv][:storage_backend_options][:log_buffer_size] = 8388608
	node[:riak][:kv][:storage_backend_options][:log_files_in_group] = 8
	node[:riak][:kv][:storage_backend_options][:log_file_size] = 268435456
	node[:riak][:kv][:storage_backend_options][:flush_log_at_trx_commit] = 1
	node[:riak][:kv][:storage_backend_options][:data_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:kv][:storage_backend_options][:log_group_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:kv][:storage_backend_options][:buffer_pool_size] = 2147483648


Bitcask
-------

	node[:riak][:kv][:storage_backend_options][:writes_per_fsync] = 1
	node[:riak][:kv][:storage_backend_options][:data_root] = "/var/lib/riak/bitcask"  
