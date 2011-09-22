Description
===========
Installs and configures the Distributed Replicated Block Device (DRBD) service for mirroring block devices between a pair of hosts. Right now it simply works in pairs, multiple hosts could be supported with a few small changes.

Requirements
============
Platform
--------
Tested with Ubuntu 10.04 and 10.10.

Recipes
=======
default
-------
Installs drbd but does no configuration.

default
-------
Given a filesystem and a partner host, configures block replication between the hosts.

Attributes
==========
* `node['drbd]['host']` - Partner to mirror with.
* `node['drbd]['mount']` - Mount point to mirror.
* `node['drbd]['master']` - Whether this node is master between the pair, defaults to `true`.

License and Author
==================

Author: Matt Ray (<matt@opscode.com>)

Copyright 2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
