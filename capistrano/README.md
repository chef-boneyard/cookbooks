DESCRIPTION
===========

Installs capistrano RubyGem and provides a definition to set up directory structure to perform capistrano deployment.

This cookbook is not necessary when using the Opscode application cookbook.

RECIPES
=======

The default recipe merely installs the capistrano RubyGem.

DEFINITIONS
===========

cap_setup
---------

The `cap_setup` definition will create the deployment directory structure for deploying applications with capistrano. For example to use the definition:

    cap_setup "my_app" do
      path "/srv/my_app"
      owner "nobody"
      group "nogroup"
      appowner "nobody"
    end

This will create the following directory structure:

    /srv/my_app
    /srv/my_app/releases
    /srv/my_app/shared
    /srv/my_app/shared/log
    /srv/my_app/shared/system

LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
