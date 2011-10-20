Description
===========

Build /etc/ssh/known_hosts based on search indexes and build it based on data retrieved by ohai.

Requirements
============

Should work on any platform that uses `/etc/ssh/known_hosts`.

Requires Chef Server for search.

Usage
=====

Searches the Chef Server for all hosts that have SSH host keys and
generates an `/etc/ssh/known_hosts`.

Changes
=======

## v0.4.0:

* COOK-493: include fqdn
* COOK-721: corrected permissions

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
