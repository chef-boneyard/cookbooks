DESCRIPTION
===========

Installs and configures ntp, optionally set up a local NTP server.

CHANGES
=======

## v1.0.1:

* Support scientific linux
* Use service name attribute in resource (fixes EL derivatives)

REQUIREMENTS
============

Should work on any Red Hat-family or Debian-family Linux distribution.

USAGE
=====

Set up the ntp attributes in a role. For example in a base.rb role applied to all nodes:

    name "base"
    description "Role applied to all systems"
    default_attributes(
      "ntp" => {
        "servers" => ["time.int.example.org"]
      }
    )

Then in an ntpserver.rb role that is applied to NTP servers (e.g., time.int.example.org):

    name "ntp_server"
    description "Role applied to the system that should be an NTP server."
    default_attributes(
      "ntp" => {
        "is_server" => "true",
        "servers" => ["0.pool.ntp.org", "1.pool.ntp.org"]
      }
    )

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
