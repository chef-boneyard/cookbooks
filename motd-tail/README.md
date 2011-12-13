Description
===========

Updates motd.tail with Chef Roles

Changes
=======

## v1.0.0:

* Current public release.

Requirements
============

Needs to be used on a system that utilizes /etc/motd.tail, e.g. Ubuntu.

Usage
=====

When the node runs, the recipe will add the list of roles to
`/etc/motd.tail` so you can tell at a glance on login what the system is.

Examples
--------

For example,

    % ssh myserver.int.example.org
    ***
    Chef-Client - myserver.int.example.org
    ubuntu
    samba_server
    netatalk_server
    munin_server
    rsyslog_server
    ***

License and Author
==================

Author:: Nathan Haneysmith <nathan@opscode.com>

Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
