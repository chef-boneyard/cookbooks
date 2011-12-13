Description
===========

Installs god gem, sets up modular configuration directory and provides
a defininition to monitor processes.

Changes
=======

## v1.0.0:

* Current public release.

Requirements
============

Sample configuration file uses mongrel_runit for managing mongrels via
runit. Opscode does not have a `mongrel_runit` cookbook, however.

## Platform:

* Debian/Ubuntu


## Cookbooks:

* runit

Usage
=====

This recipe is designed to be used through the `god_monitor` define. Create a god configuration file in your application's cookbook and then call `god_monitor`:

    god_monitor "myproj" do
      config "myproj.god.erb"
    end

A sample mongrel.god.erb is provided, though it assumes `mongrel_runit` is used. This can be used as a baseline for customization.


License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

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
