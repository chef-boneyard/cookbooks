DESCRIPTION
===========

Installs and configures Dan Bernstein's DNS tinydns, aka djbdns. Services are configured to start up under runit, daemontools or bluepill.

CHANGES
=======

The various recipes now support multiple service types. This is controlled with the `node[:djbdns][:service_type]` attribute, which is set by platform in the default recipe.

ArchLinux support has been added, as well as naively attempting other platforms by source-compiled installation with bluepill for service management.

REQUIREMENTS
============

Platform
--------

Known to work on Debian, Ubuntu, Red Hat, CentOS and ArchLinux.

Cookbooks
---------

* build-essential - for compiling the source.
* ucspi-tcp - installation of ucspi-tcp now separate cookbook.
* runit - for setting up the services.
* daemontools - alternative service configuration.
* bluepill - alternative service configuration.

ATTRIBUTES
==========

* `node[:djbdns][:tinydns_ipaddress]` - listen address for public facing tinydns server
* `node[:djbdns][:tinydns_internal_ipaddress]` - listen address for internal tinydns server
* `node[:djbdns][:public_dnscache_ipaddress]` - listen address for public DNS cache
* `node[:djbdns][:axfrdns_ipaddress]` - listen address for axfrdns
* `node[:djbdns][:public_dnscache_allowed_networks]` - subnets that are allowed to talk to the dnscache.
* `node[:djbdns][:tinydns_internal_resolved_domain]` - default domain this tinydns serves
* `node[:djbdns][:axfrdns_dir]` - default location of the axfrdns service and configuration, default `/etc/djbdns/axfrdns`
* `node[:djbdns][:tinydns_dir]` - default location of the tinydns service and configuration, default `/etc/djbdns/tinydns`
* `node[:djbdns][:tinydns_internal_dir]` - default location of the tinydns internal service and configuration, default `/etc/djbdns/tinydns_internal`
* `node[:djbdns][:public_dnscache_dir]` - default location of the public dnscache service and configuration, default `/etc/djbdns/public-dnscache`
* `node[:djbdns][:bin_dir]` - default location where binaries will be stored.
* `node[:djbdns][:axfrdns_uid]` - default uid for the axfrdns user
* `node[:djbdns][:dnscache_uid]` - default uid for the dnscache user
* `node[:djbdns][:dnslog_uid]` - default uid for the dnslog user
* `node[:djbdns][:tinydns_uid]` - default uid for the tinydns user

RESOURCES AND PROVIDERS
=======================

`djbdns_rr`
-----------

Adds a resource record for the specified FQDN.

# Actions

- :add: Creates a new entry in the tinydns data file with the `add-X` scripts in the tinydns root directory.

# Attribute Parameters

- fqdn: name attribute. specifies the fully qualified domain name of the record.
- ip: ip address for the record.
- type: specifies the type of entry. valid types are: alias, alias6, childns, host, host6, mx, and ns. default is `host`.
- cwd: current working directory where the add scripts and data files must be located. default is the node attribute `djbdns[:tinydns_internal_dir]`, usually `/etc/djbdns/tinydns-internal`.

# Example

    djbdns_rr "www.example.com" do
      ip "192.168.0.100"
      type "host"
      action :add
      notifies :run, "execute[build-tinydns-internal-data]"
    end

(The resource `execute[build-tinydns-internal-data]` should run a `make` in the tinydns root directory (aka cwd).

RECIPES
=======

default
-------

The default recipe installs djbdns software from package where available, otherwise installs from source. It also sets up the users that will run the djbdns services using the UID's specified by the attributes above. The service type to use is selected based on platform. The recipe tries to

The default recipe attempts to install djbdns on as many platforms as possible. It tries to detrmine the platform's installation method:

* Older versions of Debian and Ubuntu attempt installation from source. Ubuntu 8.10+ will use packages, as will Debian 5.0 (lenny) +.
* ArchLinux will install from AUR.
* All other distributions will install from source.

The service type is selected by platform as well:

* Debian and Ubuntu will use runit.
* ArchLinux will use daemontools.
* All other platforms will use bluepill.

Service specific users will be created as system users:

* dnscache
* dnslog
* tinydns

axfr
----

Creates the axfrdns user and sets up the axfrdns service.

cache
-----

Sets up a local DNS caching server.

`internal_server`
---------------

Sets up a server to be an internal nameserver. To modify resource records in the environment, modify the tinydns-internal-data.erb template, or create entries in a data bag named `djbdns`, and an item named after the domain, with underscores instead of spaces. Example structure of the data bag:

    {
      "id": "int_example_com",
      "ns": [
        "int.example.com": "127.0.0.1"
      ],
      "alias": [
        "first_webserver.example.com": "192.168.0.100"
      ],
      "host": [
        { "web1.example.com": "192.168.0.100" }
      ]
    }

Aliases and hosts should be an array of hashes, each entry containing the fqdn as the key and the IP as the value.

server
------

Sets up a server to be a public nameserver. To modify resource records in the environment, modify the tinydns-data.erb template. The recipe does not yet use the data bag per `internal_server` above, but will in a future release.

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
