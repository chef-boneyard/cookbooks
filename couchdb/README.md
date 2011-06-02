DESCRIPTION
===========

Installs and configures CouchDB. Optionally can install CouchDB from sources.

REQUIREMENTS
============

Requires a platform that can install Erlang from distribution packages.

## Platform

Tested on Debian 5+, Ubuntu 8.10+, OpenBSD and FreeBSD.

Also works on Red Hat, CentOS and Fedora, requires the EPEL yum repository.

## Cookbooks

* erlang

ATTRIBUTES
==========

Cookbook attributes are named under the `couch_db` keyspace. The attributes specified in the cookbook are used in the `couchdb::source` recipe only.

* `node['couch_db']['src_checksum']` - sha256sum of the default version of couchdb to download
* `node['couch_db']['src_version']` - default version of couchdb to download, used in the full URL to download.
* `node['couch_db']['src_mirror']` - full URL to download.

RECIPES
=======

default
-------

Installs the couchdb package, creates the data directory and starts the couchdb service.

source
------

Downloads the CouchDB source from the Apache project site, plus development dependencies. Then builds the binaries for installation, creates a user and directories, then sets up the couchdb service. Uses the init script provided in the cookbook.

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

