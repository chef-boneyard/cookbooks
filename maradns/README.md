Description
===========

Installs and configures maradns.

Changes
=======

## v0.8.1:

* Current public release.

Roadmap
-------

* [COOK-882] - utilize a "dns entry" databag and/or lwrp for db config
  file

Requirements
============

## Platform:

* Debian/Ubuntu

Attributes
==========

* `node['maradns']['recursive_acl']` -

Recipes
=======

default
-------

Installs the maradns package, manages the `maradns` and `zoneserver`
services and writes out the configuration files.

Resources/Providers
===================

None yet. See __Roadmap__.


Usage
=====

In order to use this recipe, create the DNS entry configuration file
as `templates/default/db.DOMAIN.erb`, where `DOMAIN` is the domain
detected by `ohai` on the node. For example, if the node's domain is
`example.com`, the file would be `db.example.com.erb`. Refer to the
maradns zone file documentation for more information on how to write
this configuration.

* http://www.maradns.org/notes.html

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009-2010, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
