Description
===========

Installs and configures ntp, optionally set up a local NTP server.

Requirements
============

Should work on any Red Hat-family or Debian-family Linux distribution.

Attributes
==========

* ntp[:is_server]

  - Boolean, should be true or false, defaults to false

* ntp[:servers] (applies to NTP Servers and Clients)

  - Array, should be a list of upstream NTP public servers.  The NTP protocol
    works best with at least 3 servers.  The NTPD maximum is 7 upstream
    servers, any more than that and some of them will be ignored by the daemon.

* ntp[:peers] (applies to NTP Servers ONLY)

  - Array, should be a list of local NTP private servers.  Configuring peer
    servers on your LAN will reduce traffic to upstream time sources, and
    provide higher availability of NTP on your LAN.  Again the maximum is 7
    peers

* ntp[:restrictions] (applies to NTP Servers only)

  - Array, should be a list of restrict lines to restrict access to NTP
    clients on your LAN.

USAGE
=====

Set up the ntp attributes in a role. For example in a base.rb role applied to all nodes:

    name "base"
    default_attributes(
      "ntp" => {
        "servers" => ["time0.int.example.org", "time1.int.example.org"]
      }
    )

Then in an ntpserver.rb role that is applied to NTP servers (e.g., time.int.example.org):

    name "base"
    default_attributes(
      "ntp" => {
        "is_server" => "true",
        "servers" => ["0.pool.ntp.org", "1.pool.ntp.org"]
        "peers" => ["time0.int.example.org", "time1.int.example.org"]
        "restrictions" => ["10.0.0.0 mask 255.0.0.0 nomodify notrap"]
      }
    )

The timeX.int.example.org used in these roles should be the names or IP addresses of internal NTP servers.

Changes
=======

## v1.1.2:

* [COOK-952] - freebsd support
* [COOK-949] - check for any virtual system not just vmware

## v1.1.0:

* Fixes COOK-376 (use LAN peers, iburst option, LAN restriction attribute)

## v1.0.1:

* Support scientific linux
* Use service name attribute in resource (fixes EL derivatives)

LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
