Description
===========

Build /etc/ssh/known_hosts based on search indexes and build it based on data retrieved by ohai.
You can also optionally put other host keys in a data bag called "ssh_known_hosts".
See below for details.

Requirements
============

Should work on any platform that uses `/etc/ssh/known_hosts`.

Requires Chef Server for search.

Usage
=====

Searches the Chef Server for all hosts that have SSH host keys and
generates an `/etc/ssh/known_hosts`.

Adding custom host keys
-----------------------

If you want to add custom host keys for hosts not in your Chef deployment (such
as github.com, for example), create a data bag called "`ssh_known_hosts`" and add
an item for each host to it that looks like this:

    {
      "id": "github",
      "fqdn": "github.com",
      "rsa": "github-rsa-host-key"
    }

You can also specify the following optional values in the data bag:

* ipaddress : Will be resolved from the fqdn value if not specified
* hostname : Short hostname form of the host without domain name
* dsa : If the host has a dsa host key, specify it as "dsa" instead of "rsa"

License and Author
==================

Author:: Scott M. Likens (<scott@likens.us>)

Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
