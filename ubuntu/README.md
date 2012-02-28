Description
===========

Sets up apt sources for Ubuntu.

Requirements
============

## Platform:

* Ubuntu

## Cookbooks:

* apt

Attributes
==========

See `attributes/default.rb` for default values.

* `node['ubuntu']['archive_url']` - archived package repo URL
* `node['ubuntu']['security_url']` - security update package repo URL

Recipes
=======

default
-------

Includes the apt default recipe to ensure the package cache is
updated and manages the `/etc/apt/sources.list` for the node's
platform code name. The template adds sources for main, restricted,
universe and multiverse.

Usage
=====

Include `recipe[ubuntu]` on systems where you want to manage the
sources.list. Currently the template enables main, restricted,
universe and multiverse for the node's codename (e.g., lucid, natty,
etc). See __Roadmap__.

License and Author
==================

Author:: Adam Jacob <adam@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
