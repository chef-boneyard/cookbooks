DESCRIPTION
===========

Installs the Teamspeak 3 beta release.

ATTRIBUTES
==========

Attributes are in the `ts3` keyspace.

* version - Specifies the version to download and set up version-specific directories. This is an override attribute so the default attributes get set correctly with it.
* arch - Specifies the architecture to download based on the node.kernel.machine. Valid values are amd64 or x86.
* url - Download URL to use. Note that the teamspeak releases are in a version specific subdirectory that isn't detected automatically, and must be modified manually when updating the version to use.

USAGE
=====

Include the teamspeak3 recipe on a node's run list to have it download and install Teamspeak 3. The software is under active development and upgrades are not handled automatically. The related attributes (see above) need to be modified for new versions, and those will be downloaded and installed. The database will be preserved for upgrades.

The Teamspeak server process will be started as a runit service. When the service is started for the first time, the runit log output (by default /etc/sv/teamspeak3/log/main/current) will have the relevant password information to manage the Teamspeak server.

LICENSE AND AUTHOR
==================

Author:: Joshua Timberman <joshua@housepub.org>

Copyright 2009-2010, Joshua Timberman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
