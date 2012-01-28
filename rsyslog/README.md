Description
===========

Installs rsyslog to replace sysklogd for client and/or server use. By default, server will be set up to log to files.

Changes
=======

## v1.0.0:

* [COOK-836] - use an attribute to specify the role to search for
  instead of relying on the rsyslog['server'] attribute.
* Clean up attribute usage to use strings instead of symbols.
* Update this README.
* Better handling for chef-solo.

Requirements
============

Platform
--------

Tested on Ubuntu 8.04, 9.10, 10.04.

For Ubuntu 8.04, the rsyslog package will be installed from a PPA via the default.rb recipe in order to get 4.2.0 backported from 10.04.

* https://launchpad.net/~a.bono/+archive/rsyslog

Ubuntu 8.10 and 9.04 are no longer supported releases and have not been tested with this cookbook.

Cookbooks
---------

* cron (http://community.opscode.com/cookbooks/cron)

Other
-----

To use the `recipe[rsyslog::client]` recipe, you'll need to set up a
role to search for. See the __Recipes__, and __Examples__ sections below.

Attributes
==========

See `attributes/default.rb` for default values.

* `node['rsyslog']['log_dir']` - If the node is an rsyslog server,
  this specifies the directory where the logs should be stored.
* `node['rsyslog']['server']` - Used to indicate whether the node
  running Chef is an rsyslog server. As of cookbook v1.0.0, this is
  determined automatically through search. The server recipe will set
  this to true. It is otherwise unused in the current version.
* `node['rsyslog']['protocol']` - Specify whether to use `udp` or
  `tcp` for remote loghost.
* `node['rsyslog']['port']` - Specify the port which rsyslog should
  connect to a remote loghost.
* `node['rsyslog']['server_role']` - Role applied to a remote
  loghost. Used by `recipe[rsyslog::client]` to search for the
  loghost.

Recipes
=======

default
-------

Installs the rsyslog package, manages the rsyslog service and sets up
basic configuration for a standalone machine.

client
------

Includes `recipe[rsyslog]`.

Uses Chef search to find a remote loghost node with the role specified
by `node['rsyslog']['server_role']` and uses its `ipaddress` attribute
to send log messages. If the node itself has the `server_role` in the
expanded roles, then the configuration is skipped. If the node had an
`/etc/rsyslog.d/server.conf` file previously configured, this file
gets removed to prevent duplicate logging. Any previous logs are not
cleaned up from the `log_dir`.

server
------

Configures the node to be an rsyslog loghost. The node should have the
role specified by `node['rsyslog']['server_role']` applied so client
nodes can find it with search. This recipe will create the logs in
`node['rsyslog']['log_dir']`, and the configuration is in
`/etc/rsyslog.d/server.conf`. This recipe also removes any previous
configuration to a remote server by removing the
`/etc/rsyslog.d/remote.conf` file. Finally, a cron job is set up to
compress logs in the `log_dir` that are older than one day.

The server configuration will set up `log_dir` for each client, by
date. Directory structure:

    <%= @log_dir %>/YEAR/MONTH/DAY/HOSTNAME/"logfile"

For example:

    /srv/rsyslog/2011/11/19/www/messages

At this time, the server can only listen on UDP *or* TCP.

Usage
=====

Use `recipe[rsyslog]` to install and start rsyslog as a basic
configured service for standalone systems.

Use `recipe[rsyslog::client]` to have nodes search for the loghost
automatically to configure remote [r]syslog.

Use `recipe[rsyslog::server]` to set up a loghost. It will listen on
`node['rsyslog']['port']` protocol `node['rsyslog']['protocol']`.

If you set up a different kind of centralized loghost (syslog-ng,
graylog2, logstash, etc), you can still send log messages to it as
long as the port and protocol match up with the server
software. See __Examples__

Examples
--------

A `base` role (e.g., roles/base.rb), applied to all nodes so they are syslog clients:

    name "base"
    description "Base role applied to all nodes
    run_list("recipe[rsyslog::client]")

Then, a role for the loghost (should only be one):

    name "loghost"
    description "Central syslog server"
    run_list("recipe[rsyslog::server]")

By default this will set up the clients search for a node with the
`loghost` role to talk to the server on TCP port 514. Change the
`protocol` and `port` rsyslog attributes to modify this.

If you're using another log server software on your loghost, such as
graylog2, you can use the role for that loghost for the search
instead. For example, if the role of your graylog2 server is
`graylog2_server`, then modify the base role for the server role:

    name "base"
    description "Base role applied to all nodes
    run_list("recipe[rsyslog::client]")
    default_attributes(
      "rsyslog" => {
        "server_role" => "graylog2_server"
      }
    )

Then make sure you have a role named `graylog2_server` applied to some
node, and `recipe[rsyslog::client]` will configure the local system to
send logs to graylog2.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
