Description
===========

Provides recipes for manipulating selinux policy enforcement

Requirements
============

RHEL family distribution or other Linux system that uses SELinux.

## Platform:

Tested on RHEL 5.6, 6.0 and 6.1.

Usage
=====

SELinux is enforcing by default on RHEL family distributions, however the use of SELinux has complicated considerations when using configuration management. Often, users are recommended to set SELinux to permissive mode, or disabled completely. To ensure that SELinux is permissive or disabled, choose the appropriate recipe (`selinux::permissive`, `selinux::disabled`) and apply it to the node early in the run list. For example in a `base` role used by all RHEL systems:

    name "base"
    description "Base role applied to all nodes."
    run_list(
      "recipe[selinux::permissive]",
    )

Roadmap
=======

Use a node attribute to determine which recipe to load automatically from selinux::default.

Add LWRP/Libraries for manipulating security contexts for files and services managed by Chef.

License and Author
==================

Author:: Sean OMeara (<someara@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
