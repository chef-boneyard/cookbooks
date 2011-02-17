Description
===========

Installs and configures PowerDNS (pdns). Sets up a recursor by default and can set up an Authoritative Server with multiple backends.

Requirements
============

Tested on ArchLinux, and Ubuntu. Should work on Debian and Red Hat family, but needs EPEL repository enabled.

Attributes
==========

Attributes used by the recipes and templates. Some correspond to configuration file values. The default setting in the attribute matches the default value in PowerDNS itself where possible and is populated in the appropriate template (`/etc/powerdns/recursor.conf` and `/etc/powerdns/pdns.conf` respectively for the recursor or server). Where applicable, values are namespaced in the attributes by `server` or `recursor`.

Where a list of values is used by the PowerDNS config, we use an Array value populated with the defaults. This gives more flexibility in recipes to manipulate the list easily using Ruby Array methods.

* `node["pdns"]["user"]` - User to setuid the pdns daemons, default pdns.
* `node["pdns"]["group"]` - Group to setuid the pdns daemons, default pdns.
* `node["pdns"]["server"]["config_dir"]` - Config directory location for pdns.conf.
* `node["pdns"]["recursor"]["config_dir"]` - Config directory location for recursor.conf.

server
------

* `node["pdns"]["server"]["backend"]` - Selects the PDNS database backend, default 'sqlite3' (only option available at this time).
* `node["pdns"]["server"]["sqlite_file"]` - Filename for the sqlite database. Only used if the backend is gsqlite.
* `node["pdns"]["server"]["local_address"]` - Array list of the local IPv4 or IPv6 addresses to bind to, corresponds to the recursor.conf value `local-address` default ["127.0.0.1"] under the assumption that the recursor is used with an Authoritative Server on the same system and passes local zone requests to the loopback.

recursor
--------

* `node["pdns"]["recursor"]["allow_from"]` - Array list of netmasks to recurse, corresponds to recursor.conf value `allow-from`, default ["127.0.0.0/8", "0.0.0.0/8", "92.168.0.0/16", "72.16.0.0/12", ":1/128", "e80::/10"].
* `node["pdns"]["recursor"]["auth_zones"]` - Array list of 'zonename=filename' pairs served authoritatively, corresponds to recursor.conf value `auth-zones`, default [].
* `node["pdns"]["recursor"]["forward_zones"]` - Array list of 'zonename=IP' pairs. Queries for the zone are forwarded to the specified IP, corresponds to recursor.conf value `forward-zones`, default [].
* `node["pdns"]["recursor"]["forward_zones_recurse"]` - Array list of 'zonename=IP' pairs. Like `forward_zones` above, sets the `recursion_desired` bit to 1, corresponds to recursor.conf value `forward-zones-recurse`, default [].
* `node["pdns"]["recursor"]["local_address"]` - Array list of the local IPv4 or IPv6 addresses to bind to, corresponds to the recursor.conf value `local-address` default [ipaddress] under the assumption that the recursor is used with an Authoritative Server on the same system.
* `node["pdns"]["recursor"]["local_port"]` - Local port to bind, default '53'.

Recipes
=======

default
-------

Includes the `pdns::recursor` recipe.

recursor
--------

Sets up a PowerDNS Recursor.

server
------

Sets up a PowerDNS Authoritative Server. Uses the SQLite backend by default with the `pdns::sqlite` recipe.

sqlite
------

Sets up an SQLite database backend for the `pdns::server`. This backend is the default.

Usage
=====

To set up a Recursor, simply put `recipe[pdns]` in the run list. Modify the attributes via a role or on the node directly as required for the local configuration. If using the recursor with an Authoritative Server running on the same system, the local address and port should be changed to a public IP and the forward zones recurse setting to point at the loopback for the local zone. This is generally assumed, and the default listen interface for the recursor is set to the nodes ipaddress attribute.

To set up an authoritative server, put `recipe[pdns::server]` in the run list. If another backend besides SQLite is desired, change the `node["pdns"]["server"]["backend"]` attribute.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2010, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
