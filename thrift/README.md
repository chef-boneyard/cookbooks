Description
===========

Installs Thrift from source.

Changes
=======

Requirements
============

## Platform

* Ubuntu 11.10

(Ubuntu 10.04 was tested but thrift would not compile cleanly)

## Cookbooks

Opscode cookbooks:

* build-essential
* java
* boost

Usage
=====

Include the Thrift recipe to install Thrift from source on your systems.

  include_recipe "thrift"

Changes
=======

## v1.0.0:

* [COOK-904] - install version 0.8, requires Ubuntu 11.10

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2009-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
