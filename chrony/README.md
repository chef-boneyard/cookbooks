Description
===========
Configures the time synchronization application `chrony` as a client or server.

Recipes
=======

client
------
Configures the node to use the `chrony` application to keep the node's clock synced. If there is a node using the `chrony::server` recipe, the client will attempt to sync with it. If there is not an available server, the attribute list `[:chrony][:servers]` is used (defaults is `[0-3].debian.pool.ntp.org`).

default
-------
The default recipe passes through to the client recipe.

server
------
The node will use the `chrony` application to provide time to nodes using the `chrony::client` recipe. The server sets its own time against the attribute list `[:chrony][:servers]` (defaults is `[0-3].debian.pool.ntp.org`).
    
Usage
=====
Nodes using the `chrony::client` recipe will attempt to sync time with nodes using the `chrony::server` recipe. If there are no `chrony::server` nodes found the contents of the attribute list `[:chrony][:servers]` is used (defaults is `[0-3].debian.pool.ntp.org`).

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

