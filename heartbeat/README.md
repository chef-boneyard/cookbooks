Description
===========

Installs, but does not configure heartbeat.

Changes
=======

## v0.7.1:

* Current public release.

Roadmap
-------

Add management of configuration files, possibly with Chef search().

* /etc/ha.d/ha.cf
* /etc/ha.d/haresources
* /etc/ha.d/authkeys

Requirements
============

## Platform:

* Ubuntu 10.04+
* Debian 6.0+

Recipes
=======

default
-------

Installs the heartbeat and heartbeat-dev packages, and manages the
heartbeat service. The recipe does not at this time manage any configuration.

Usage
=====

On systems that need to be HA pairs, use this cookbook. Set up one to
be the primary, and the other to be secondary with a clever role name,
like "heartbeat-primary" and "heartbeat-secondary". To manage the
heartbeat configuration files, modifications to the recipe to add
template resources is required at this time. See __Roadmap__ above.

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

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
