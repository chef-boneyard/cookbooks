Description
===========

Installs and configures nscd.

Requirements
============

## Platform:

* Debian/Ubuntu
* RHEL/CentOS

Recipes
=======

default
-------

Installs nscd, manages the nscd service and makes available commands
to clear the nscd databases (passwd and group) so they can be notified
in other recipes (such as when managing openldap).

Usage
=====

If you're using nscd, add this recipe. If you need to notify the clear
commands, e.g.,

    cookbook_file "/etc/nsswitch.conf" do
      source "nsswitch.conf"
      notifies :run, "execute[nscd-clear-passwd]", :immediately
      notifies :run, "execute[nscd-clear-group]", :immediately
    end

License and Author
==================

Author:: Joshua Timberman

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
