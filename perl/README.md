Description
===========

Manages Perl installation and provides `cpan_module`, to install modules 
from... CPAN.

Changes
=======

## v0.10.0:

* Current released version

Requirements
============

## Platform:

* Debian/Ubuntu
* RHEL/CentOS
* ArchLinux

Usage
=====

To install a module from CPAN:

    cpan_module "App::Munchies"

Optionally, installation can forced with the 'force' parameter.

    cpan_module "App::Munchies"
      force true
    end

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
