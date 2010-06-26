DESCRIPTION
===========

Installs and configures Dan Bernstein's DNS tinydns, aka djbdns. Services are configured to start up under runit.

REQUIREMENTS
============

Platform
--------

Known to work on Debian, Ubuntu, Red Hat and CentOS.

Cookbooks
---------

* build-essential - for compiling the source.
* runit - for setting up the services.

ATTRIBUTES
==========

* `node[:djbdns][:tinydns_ipaddress]` - listen address for public facing tinydns server
* `node[:djbdns][:tinydns_internal_ipaddress]` - listen address for internal tinydns server
* `node[:djbdns][:public_dnscache_ipaddress]` - listen address for public DNS cache
* `node[:djbdns][:axfrdns_ipaddress]` - listen address for axfrdns
* `node[:djbdns][:public_dnscache_allowed_networks]` - subnets that are allowed to talk to the dnscache.
* `node[:djbdns][:tinydns_internal_resolved_domain]` - default domain this tinydns serves
* `node[:djbdns][:bin_dir]` - default location where binaries will be stored.
* `node[:djbdns][:axfrdns_uid]` - default uid for the axfrdns user
* `node[:djbdns][:dnscache_uid]` - default uid for the dnscache user
* `node[:djbdns][:dnslog_uid]` - default uid for the dnslog user
* `node[:djbdns][:tinydns_uid]` - default uid for the tinydns user

RECIPES
=======

default
-------

The default recipe installs djbdns software from package where available, otherwise installs from source. It also sets up the users that will run the djbdns services using the UID's specified by the attributes above.

axfr
----

Creates the axfrdns user and sets up the axfrdns service.

cache
-----

Sets up a local DNS caching server.

internal_server
---------------

Sets up a server to be an internal nameserver. To modify resource records in the environment, modify the tinydns-internal-data.erb template.

server
------

Sets up a server to be a public nameserver. To modify resource records in the environment, modify the tinydns-data.erb template.

LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
