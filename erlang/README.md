DESCRIPTION
===========

Installs Erlang from package (optionally with GUI tools) or from source code.
Optionally installs Erlang Quickcheck

REQUIREMENTS
============

Cookbooks
--------

build-essential
openssl

Platform
--------

Installation based on package works on Debian/Ubuntu systems
Installation from source code has been tested on Ubuntu 10.04

ATTRIBUTES
==========

* `node[:erlang][:install_method]` - "package" (default) or "source"
* `node[:erlang][:version]` - Erlang Version to Install (e.g. "R14B02"). Used only during installation from source
* `node[:erlang][:gui_tools]` - Optionally installs GUI tools. Used only during installation from package
* `node[:erlang][:eqc][:install]` = Optionally installs Erlang QuickCheck
* `node[:erlang][:eqc][:url]` = URL for Erlang QuickCheck
* `node[:erlang][:eqc][:licence]` = License code for Erlang QuickCheck

RECIPES
=======

package
-------

source
-------

USAGE
=======

Simply include the desired recipe (package or source) in your run list

LICENSE AND AUTHOR
==================

Author:: Roberto Aloi (<roberto@erlang-solutions.com>)

Copyright 2011, Erlang Solutions Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

