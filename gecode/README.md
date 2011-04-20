Description
===========

Installs Gecode 3.5.0+ development package.

Requirements
============

Tested on Ubuntu and Debian with Opscode APT repository and build from source.

Tested on CentOS for build from source. See USAGE for information on installing RPMs.

Requires the following cookbooks:

* apt - for installing packages from apt.opscode.com
* build-essential - for compiling from source

Usage
=====

The recipe is primarily used to install gecode's development package or from source in order to install the `dep_selector` gem, which needs to compile native extensions.

Note that compiling gecode takes a long time, up to ~30 minutes on a 4 core Macbook Pro.

On Debian and Ubuntu systems, the recipe will attempt to install packages from apt.opscode.com. It uses the apt repository LWRP in Opscode's apt cookbook to enable the repository.

On Red Hat family distros, the recipe will attempt to install gecode from source. To install using a package the recipe needs to be updated to account for a package repository. Implementation varies depending on the package repository. For example, to retrieve the /etc/yum.repos.d/somewhere.repo that has the package available, add a condition to the main 'if' block:

    remote_file "/etc/yum.repos.d/somewhere.repo" do
      source "http://somewhere.example.com/yum/el5/somewhere.repo"
      owner "root"
      group "root"
      mode 0644
    end

    package "gecode-devel"

License and Author
==================

Author:: Chris Walters (<cw@opscode.com>)
Author:: Nuo Yan (<nuo@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
