Description
===========

Installs the "emacs" package to install the worlds most flexible, customizable text editor.

Changes
=======

## v0.7.0:

* Initial public release

Roadmap
-------

* [COOK-551] - FreeBSD Support
* [COOK-839] - install non-X11 package by setting an attribute

Requirements
============

A package named "emacs" must be available via the native package manager for the Platform.

Attributes
==========

Does not use any attributes yet. See __Roadmap__.

Recipes
=======

default
-------

Installs the emacs package.

Usage
=====

Simply add `recipe[emacs]` to the run list of a base role that gets applied to all systems.

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
