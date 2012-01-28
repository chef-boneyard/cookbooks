Description
===========

Installs and configures varnish.

Changes
=======

## v 0.8.0:

* Current public release.

Roadmap
-------

* COOK-648 - add RHEL support
* COOK-873 - better configuration control via attributes

Requirements
============

## Platform:

Tested on:

* Ubuntu 10.04
* Debian 6.0

Attributes
==========

* `node['varnish']['dir']` - location of the varnish configuration
  directory
* `node['varnish']['default']` - location of the `default` file that
  controls the varnish init script on Debian/Ubuntu systems.

Recipes
=======

default
-------

Installs the varnish package, manages the default varnish
configuration file, and the init script defaults file.

Usage
=====

On systems that need a high performance caching server, use
`recipe[varnish]`. Additional configuration can be done by modifying
the `default.vcl.erb` and `ubuntu-default.erb` templates. By default
the `ubuntu-default.erb` is set up for minimal configuration with no VCL.

License and Author
==================

Author:: Joe Williams <joe@joetify.com>

Copyright:: 2008-2009, Joe Williams

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
