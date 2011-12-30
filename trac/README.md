Description
===========

Installs trac software and creates an environment with an Apache2
virtual host.

Changes
=======

## v0.1.1:

* Current public release.

Usage
=====

Include the recipe 'trac' in the run list.

This cookbook does not:

- Set up the subversion repository

You may also need to enable the authentication mechanism of your
preference in the trac.conf.erb template.

License and Author
==================

Copyright 2009, Peter Crossley <peterc@xley.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
