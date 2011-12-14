Description
===========

Installs the "emacs" package to install the worlds most flexible, customizable text editor.

Changes
=======

### v0.8.2:

* [COOK-551] - FreeBSD Support
* [COOK-839] - install non-X11 package by setting an attribute

### v0.7.0:

* Initial public release

Requirements
============

## Platform

* Debian/Ubuntu
* Red Hat/CentOS/Scientific/Fedora
* FreeBSD

Should work on any platform that has a default provider for the `package` resource and a package named `emacs` avaialble in the default package manager repository.

On FreeBSD, Chef version 0.10.6 is required for fixes to the ports package provider.

Attributes
==========

* `node['emacs']['packages']` - An array of Emacs package names to install. Defaults to the "No X11" name based on platform and falls back to "emacs".

Recipes
=======

default
-------

Installs the emacs package.

Usage
=====

Simply add `recipe[emacs]` to the run list of a base role that gets applied to all systems. Modify the `node['emacs']['packages']` attribute if the default package name for your platform is unavailable or incorrect (see `attributes/default.rb`). You should modify this with an attribute in a role applied to the node. For example:

    name "base"
    description "base role is applied to all nodes"
    run_list("recipe[emacs]")
    default_attributes(
      "emacs" => {
        "packages" => ["emacs-nox"]
      }
    )

As this is an array you can append other emacs-related packages, such as to make configuration modes available.

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
