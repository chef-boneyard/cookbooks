DESCRIPTION
===========

Refreshes the pacman package cache from the FTP servers and provides LWRPs related to pacman

REQUIREMENTS
============

Platform: ArchLinux. Pacman is not relevant on other platforms.

RESOURCES
=========

`pacman_group`
--------------

Use the `pacman_group` resource to install or remove pacman package groups. Note that at this time the LWRP will check if the group is installed but doesn't do a lot of error checking or handling. File a ticket on the COOK project at tickets.opscode.com for improvements and feature requests.

The `options` parameter can be used to pass arbitrary options to the pacman command.

`pacman_aur`
------------

Use the `pacman_aur` resource to install packages from ArchLinux's AUR repository.

### Actions:

* :build - Builds the package.
* :install - Installs the built package.

### Parameters:

* version - hardcode a version
* builddir - specify an alternate build directory, defaults to `Chef::Config[:file_cache_path]/builds`.
* options - pass arbitrary options to the pacman command.
* `pkgbuild_src` - whether to use an included PKGBUILD file, put the PKGBUILD file in in the `files/default` directory.
* patches - array of patch names, as files in `files/default` that should be applied for the package.

http://aur.archlinux.org/

USAGE
=====

Include `recipe[pacman]` early in the run list, preferably first, to ensure that the package caches are updated before trying to install new packages.


LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: Opscode, Inc. (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
