Description
===========

Installs GNU parallel.

Requirements
============

Requires `build-essential` cookbook for installing from source.

On OS X, requires the `homebrew` cookbook, available from http://community.opscode.com/cookbooks/homebrew.

Attributes
==========

* `node['gnu_parallel']['install_method']` - Specifies the recipe to use for installing homebrew. On OSX, homebrew is used, on everything else source is used, as there are no native packages for GNU parallel in most distributions.
* `node['gnu_parallel']['url']` - base url to download from. Default is the GNU software distribution FTP server.
* `node['gnu_parallel']['version']` - version of parallel to install.
* `node['gnu_parallel']['checksum']` - checksum of the source tarball.
* `node['gnu_parallel']['configure_options']` - array of options to pass to ./configure for compiling parallel.

Usage
=====

Include recipe in a run list, get some GNU parallel installed. Set attributes (see attributes file for available values and defaults).

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

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
