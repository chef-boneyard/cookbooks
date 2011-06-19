DESCRIPTION
===========

Installs rsyslog to replace sysklogd for client and/or server use. By default, server will be set up to log to files.

REQUIREMENTS
============

Platform
--------

Tested on Ubuntu 8.04, 9.10, 10.04.

For Ubuntu 8.04, the rsyslog package will be installed from a PPA via the default.rb recipe in order to get 4.2.0 backported from 10.04.

* https://launchpad.net/~a.bono/+archive/rsyslog

Ubuntu 8.10 and 9.04 are no longer supported releases and have not been tested with this cookbook.

Cookbooks
---------

* cron (http://cookbooks.opscode.com/cookbooks/cron)

ATTRIBUTES
==========

* `rsyslog[:log_dir]` - specify the directory to store logs (applicable to server only), default /srv/rsyslog
* `rsyslog[:server]` - specify the remote rsyslog server. default false (no remote server)
* `rsyslog[:protocol]` - specify whether to use udp or tcp for remote log transmission. tcp is default.

USAGE
=====

To replace the sysklogd syslog service with rsyslog:

    include_recipe "rsyslog"

To set up a client with a remote [r]syslog server:

    include_recipe "rsyslog::client"

By default, this cookbook will use TCP so the server should be configured for TCP. This can be done easily with the server recipe:

    include_recipe "rsyslog::server"

To switch to UDP, change the rsyslog[:protocol] attribute. Note this needs to be done on each client as well.

Also, the server configuration will set up `log_dir` for each client, by date. Structure:

    <%= @log_dir %>/YEAR/MONTH/DAY/HOSTNAME/"logfile"

LICENSE AND AUTHOR
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
