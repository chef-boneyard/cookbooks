Description
===========
Configures the time synchronization application `chrony` as a client or master timeserver, maintaining the accuracy of the system clock (similar to NTP). Isolated networks are supported as well.

Recipes
=======

client
------
Configures the node to use the `chrony` application to keep the node's clock synced. If there is a node using the `chrony::master` recipe, the client will attempt to sync with it. If there is not an available master, the attribute list `[:chrony][:servers]` is used (defaults are `[0-3].debian.pool.ntp.org`). If there is a master node, the `[:chrony][:allowed]` and `[:chrony][:initslewstep]` will be set to allow for syncing with the master.

default
-------
The default recipe passes through to the client recipe.

master
------
The node will use the `chrony` application to provide time to nodes using the `chrony::client` recipe. The master sets its own time against the attribute list `[:chrony][:servers]` (defaults are `[0-3].debian.pool.ntp.org`). Access to this master is restricted by the `[:chrony][:allowed]` attribute set in the recipe (default is to the x.y.* subnet). If the `[:chrony][:servers]` are empty, the master will set its `[:chrony][:initslewstep]` to the first 3 client nodes returned by search (it will set it to the first 3 `[:chrony][:servers]` otherwise).
    
Usage
=====
Nodes using the `chrony::client` recipe will attempt to sync time with nodes using the `chrony::master` recipe. If there are no `chrony::master` nodes found, the contents of the attribute list `[:chrony][:servers]` are used (defaults are `[0-3].debian.pool.ntp.org`). 

The current configurations are supported:
1) Clients with direct NTP server access
2) A master with direct NTP server access with clients pointing to it
3) Isolated master and clients, using the `initslewstep` to keep the master and clients synced. Manually setting the server's time may be required.

License and Author
==================

Author:: Matt Ray (<matt@opscode.com>)

Copyright 2011 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

