Description
===========

Installs DJB's Daemontools and includes a service LWRP.

Requirements
============

Should work on ArchLinux, Debian and Ubuntu. May work on Red Hat family distributions.

Requires build-essential and ucspi-tcp cookbooks.

Attributes
==========

* `node[:daemontools][:bin_dir]` - Sets the location of the binaries for daemontools, default is selected by platform, or '/usr/local/bin' as a fallback.

Resource/Provider
=================

This cookbook includes an LWRP for managing daemontools services.

Usage
=====

License and Author
==================

Author: Joshua Timberman (<joshua@opscode.com>)

Copyright 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
