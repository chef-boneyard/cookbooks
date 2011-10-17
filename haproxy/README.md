Description
===========

Installs haproxy and prepares the configuration location.

Changes
=======

## v1.0.3:

* [COOK-620] haproxy::app_lb's template should use the member cloud private IP by default

## v1.0.2:

* fix regression introduced in v1.0.1

## v1.0.1:

* account for the case where load balancer is in the pool

## v1.0.0:

* Use `node.chef_environment` instead of `node['app_environment']`

Requirements
============

## Platform

Tested on Ubuntu 8.10 and higher.

## Cookbooks:

Attributes
==========

* `node['haproxy']['member_port']` - the port that member systems will be listening on, default 80
* `node['haproxy']['enable_admin']` - whether to enable the admin interface. default true. Listens on port 22002.
* `node['haproxy']['app_server_role']` - used by the `app_lb` recipe to search for a specific role of member systems. Default `webserver`.

Usage
=====

Use either the default recipe or the `app_lb` recipe.

When using the default recipe, modify the haproxy.cfg.erb file with listener(s) for your sites/servers.

The app_lb recipe is designed to be used with the application cookbook, and provides search mechanism to find the appropriate application servers. Set this in a role that includes the haproxy::app_lb recipe. For example,

    name "load_balancer"
    description "haproxy load balancer"
    run_list("recipe[haproxy::app_lb]")
    override_attributes(
      "haproxy" => {
        "app_server_role" => "webserver"
      }
    )

The search uses the node's `chef_environment`. For example, create `environments/production.rb`, then upload it to the server with knife

    % cat environments/production.rb
    name "production"
    description "Nodes in the production environment."
    % knife environment from file production.rb

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
