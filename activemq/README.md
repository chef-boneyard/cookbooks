Description
===========

Installs activemq and sets up a service using the init script that comes with it.

Changes
=======

## v1.0.2:

* [COOK-800] - activemq cookbook should install 5.5.1 by default
* [COOK-872] - activemq home directory isn't explicitly created

Requirements
============

## Platform:

Tested on Ubuntu 10.04 and CentOS 5.5. Should work on any Debian or Red Hat family distributions.

## Cookbooks:

* java

Attributes
==========

* `node['activemq']['mirror']` - download URL up to the activemq/apache-activemq directory.
* `node['activemq']['version']` - version to install.
* `node['activemq']['home']` - directory to deploy to (/opt by default)
* `node['activemq']['wrapper']['max_memory']` - maximum amount of memory to use for activemq.
* `node['activemq']['wrapper']['useDedicatedTaskRunner']` - whether to use the dedicated task runner

Usage
=====

Simply add `recipe[activemq]` to a run list.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
