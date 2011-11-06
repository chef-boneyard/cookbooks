Description
===========

The [Windows Installer XML](http://wix.sourceforge.net/) (WiX) is a toolset that builds Windows installation packages from XML source code. The toolset supports a command line environment that developers may integrate into their build processes to build MSI and MSM setup packages. This cookbook installs the full WiX suite of tools.

Requirements
============

Platform
--------

* Windows Server 2003 R2
* Windows 7
* Windows Server 2008 (R1, R2)

Cookbooks
---------

* windows

Attributes
==========

* `node['wix']['home']` - location to install WiX files to.  default is `%SYSTEMDRIVE%\wix`

Usage
=====

default
-------

Downloads and installs WiX to the location specified by `node['wix']['home']`.  Also ensures `node['wix']['home']` is in the system path.

Changes/Roadmap
===============

## Future

* Resource/Provider for creating individual WiX projects.

## 1.0.0:

* initial release

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

