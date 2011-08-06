Description
===========

Provides recipes for manipulating selinux policy enforcement

---
Requirements
============
Selinux enabled RHEL derived linux distro

---
Platform
========
redhat centos scientific fedora

---
Attributes
==========
none

---
Usage
=====

Include early on in a nodes run list:

computron:~/myinfrastructure$ cat roles/base.rb 

name "base"
description "Base role applied to all nodes."
run_list(
  "recipe[selinux::disabled]",
)

---
License and Author
==================

Author:: Sean OMeara (<someara@opscode.com>)

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

