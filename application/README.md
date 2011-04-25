Application cookbook
====================

This cookbook is initially designed to be able to describe and deploy web applications. Currently supported:

* Rails
* Java
* Django
* PHP

Other application stacks (Rack, WSGI, etc) will be supported as new recipes at a later date.

This cookbook aims to provide primitives to install/deploy any kind of application driven entirely by data defined in an abstract way through a data bag.

---
Requirements
============

Chef 0.9.14 or higher required.

The following Opscode cookbooks are dependencies:

* runit
* unicorn
* passenger_apache2
* tomcat
* python
* gunicorn
* apache2
* php

---
Recipes
=======

The application cookbook contains the following recipes.

default
-------

Searches the `apps` data bag and checks that a server role in the app exists on this node, adds the app to the run state and uses the role for the app to locate the recipes that need to be used. The recipes listed in the "type" part of the data bag are included by this recipe, so only the "application" recipe needs to be in the node or role `run_list`.

See below regarding the application data bag structure.

django
------

Using the node's `run_state` that contains the current application in the search, this recipe will:

* create an application specific virtualenv
* install required packages and pips
* set up the deployment scaffolding
* creates `settings_local.py` file with the database connection information if required
* performs a revision-based deploy

This recipe can be used on nodes that are going to run the application, or on nodes that need to have the application code checkout available such as supporting utility nodes or a configured load balancer that needs static assets stored in the application repository.

For pip requirements.txt files: ensure the requirements.txt file is present in the root of the application code (APP_ROOT/requirements.txt) or named after the node's current app_environment in a directory named requirements (requirements/production.txt) and `pip install -r` will be run before migrations.

In order to manage running database migrations (python manage.py migrate), you can use a role that sets the `run_migrations` attribute for the application (`my_app`, below) in the correct environment (production, below). Note the data bag item needs to have migrate set to true. See the data bag example below.

    {
      "name": "my_app_run_migrations",
      "description": "Run db:migrate on demand for my_app",
      "json_class": "Chef::Role",
      "default_attributes": {
      },
      "override_attributes": {
        "apps": {
          "my_app": {
            "production": {
              "run_migrations": true
            }
          }
        }
      },
      "chef_type": "role",
      "run_list": [
      ]
    }

Simply apply this role to the node's run list when it is time to run migrations, and the recipe will remove the role when done.  Since Django does not have a standard database migration function built into the core framework, we assume the popular [South framework](http://south.aeracode.org/) is being used.

gunicorn
--------

Requires `gunicorn` cookbook.

Gunicorn is installed, default attributes are set for the node and an app specific gunicorn config and runit service are created.

java_webapp
-----------

Using the node's `run_state` that contains the current application in the search, this recipe will:

* install required packages
* set up the deployment scaffolding
* create the context configuration for the servlet container
* performs a `remote_file` deploy.

The servlet container context configuration (`context.xml`) exposes the following JNDI resources which can be referenced by the webapp's deployment descriptor (web.xml):

* A JDBC datasource for all databases in the node's current `app_environment`.  The datasource uses the information (including JDBC driver) specified in the data bag item for the application.
* An Environment entry that matches the node's current `app_environment` attribute value.  This is useful for loading environment specific properties files in the web application. 

This recipe assumes some sort of build process, such as Maven or a Continuous Integration server like Hudson, will create a deployable artifact and make it available for download via HTTP (such as S3 or artifactory).

mod\_php\_apache2
-----------------

Requires `apache2` cookbook. Sets up a mod_php vhost template for the application using the `apache2` cookbook's `web_app` definition. See data bag example below.

passenger_apache2
-----------------

Requires `apache2` and `passenger_apache2` cookbooks. Sets up a passenger vhost template for the application using the `apache2` cookbook's `web_app` definition. Use this with the `rails` recipe, in the list of recipes for a specific application type. See data bag example below.

php
---

Using the node's `run_state` that contains the current application in the search, this recipe will:

* install required packages and pears/pecls
* set up the deployment scaffolding
* creates a `local_settings.php` (specific file name and project path is configurable) file with the database connection information if required
* performs a revision-based deploy

This recipe can be used on nodes that are going to run the application, or on nodes that need to have the application code checkout available such as supporting utility nodes or a configured load balancer that needs static assets stored in the application repository.

Since PHP projects do not have a standard `local_settings.php` file (or format) that contains database connection information. This recipe assumes you will provide a template in an application specific cookbook.  See additional notes in the 'Application Data Bag' section below.

rails
-----

Using the node's `run_state` that contains the current application in the search, this recipe will:

* install required packages and gems
* set up the deployment scaffolding
* creates database and memcached configurations if required
* performs a revision-based deploy.

This recipe can be used on nodes that are going to run the application, or on nodes that need to have the application code checkout available such as supporting utility nodes or a configured load balancer that needs static assets stored in the application repository.

For Gem Bundler: include `bundler` or `bundler08` in the gems list.  `bundle install` or `gem bundle` will be run before migrations.  The `bundle install` command is invoked with the `--deployment` and `--without` flags following [Bundler best practices](http://gembundler.com/deploying.html).

For config.gem in environment: `rake gems:install RAILS_ENV=<node environment>` will be run when a Gem Bundler command is not.

In order to manage running database migrations (rake db:migrate), you can use a role that sets the `run_migrations` attribute for the application (`my_app`, below) in the correct environment (production, below). Note the data bag item needs to have migrate set to true. See the data bag example below.

    {
      "name": "my_app_run_migrations",
      "description": "Run db:migrate on demand for my_app",
      "json_class": "Chef::Role",
      "default_attributes": {
      },
      "override_attributes": {
        "apps": {
          "my_app": {
            "production": {
              "run_migrations": true
            }
          }
        }
      },
      "chef_type": "role",
      "run_list": [
      ]
    }

Simply apply this role to the node's run list when it is time to run migrations, and the recipe will remove the role when done.

tomcat
-------

Requires `tomcat` cookbook.

Tomcat is installed, default attributes are set for the node and the app specific context.xml is symlinked over to Tomcat's context directory as the root context (ROOT.xml).

unicorn
-------

Requires `unicorn` cookbook.

Unicorn is installed, default attributes are set for the node and an app specific unicorn config and runit service are created.

---
Deprecated Recipes
==================

The following recipes are deprecated and have been removed from the cookbook. To retrieve an older version, reference commit 4396ce6.

`passenger-nginx`
`rails_nginx_ree_passenger`

---
Application Data Bag 
=====================

The applications data bag expects certain values in order to configure parts of the recipe. Below is a paste of the JSON, where the value is a description of the key. Use your own values, as required. Note that this data bag is also used by the `database` cookbook, so it will contain database information as well. Items that may be ambiguous have an example.

The application used in examples is named `my_app` and the environment is `production`. Most top-level keys are Arrays, and each top-level key has an entry that describes what it is for, followed by the example entries. Entries that are hashes themselves will have the description in the value.

Note about "type": the recipes listed in the "type" will be included in the run list via `include_recipe` in the application default recipe based on the type matching one of the `server_roles` values.

Note about packages, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the package provider.

Rail's version additional notes
-------------------------------

Note about `databases`, the data specified will be rendered as the `database.yml` file. In the `database` cookbook, this information is also used to set up privileges for the application user, and create the databases.

Note about gems, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the package provider.

An example is data bag item is included in this cookbook at `examples/data_bags/apps/rails_app.json`.

Java webapp version additional notes
------------------------------------

Note about `databases`, the data specified will be rendered as JNDI Datasource `Resources` in the servlet container context confiruation (`context.xml`) file. In the `database` cookbook, this information is also used to set up privileges for the application user, and create the databases.

An example is data bag item is included in this cookbook at `examples/data_bags/apps/java_app.json`.

Django version additional notes
-------------------------------

Note about `databases`, the data specified will be rendered as the `settings_local.py` file. In the `database` cookbook, this information is also used to set up privileges for the application user, and create the databases.

Note about pips, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the python_pip package provider.

The `local_settings_file` value may be used to supply an alternate name for the environment specific `settings_local.py`, since Django projects do not have a standard name for this file.

An example is data bag item is included in this cookbook at `examples/data_bags/apps/django_app.json`.

PHP version additional notes
----------------------------

Note about `databases`, the data specified will be rendered as the `local_settings.php` file. In the `database` cookbook, this information is also used to set up privileges for the application user, and create the databases.

Note about pears/pecls, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the php_pear package provider.

The `local_settings_file` value is used to supply the name, and relative local project path, for the environment specific `local_settings.php`, since PHP projects do not have a standard name (or location) for this file.

For applications that look for this file in the project root just supply a name:

MediaWiki:

    "local_settings_file": "LocalSettings.php"
    
Wordpress:

    "local_settings_file": "wp-config.php"

For applications that expect the file nested within the project root, you can supply a relative path:

CakePHP:

    "local_settings_file": "app/config/database.php"

The template used to render this `local_settings.php` file is assumed to be provided in an application specific cookbook named after the application being deployed.  For example if you were deploying code for an application named `mediawiki` you would create a cookbook named `mediawiki` and in that cookbook place a template named `LocalSettings.php.erb`:

    mediawiki/
    +-- files
    |   +-- default
    |       +-- schema.sql
    +-- metadata.rb
    +-- README.md
    +-- recipes
    |   +-- db_bootstrap.rb
    |   +-- default.rb
    +-- templates
        +-- default
            +-- LocalSettings.php.erb

The template will be passed the following variables which can be used to dynamically fill values in the ERB:

* path - fill path to the 'current' project path
* host - database master fqdn
* database - environment specific database information from the application's data bag item
* app - Ruby mash representation of the complete application data bag item for this app, useful if other arbitrary config data has been stashed in the data bag item.

A few example `local_settings` templates are included in this cookbook at `examples/templates/defaults/*`:

* MediaWiki - LocalSettings.php.erb
* Wordpress - wp-config.php.erb

An example is data bag item is included in this cookbook at `examples/data_bags/apps/php_app.json`.

---
Usage
=====

To use the application cookbook, we recommend creating a role named after the application, e.g. `my_app`. This role should match one of the `server_roles` entries, that will correspond to a `type` entry, in the databag. Create a Ruby DSL role in your chef-repo, or create the role directly with knife.

    % knife role show my_app
    {
      "name": "my_app",
      "chef_type": "role",
      "json_class": "Chef::Role",
      "default_attributes": {
      },
      "description": "",
      "run_list": [
        "recipe[application]"
      ],
      "override_attributes": {
      }
    }

Also recommended is a cookbook named after the application, e.g. `my_app`, for additional application specific setup such as other config files for queues, search engines and other components of your application. The `my_app` recipe can be used in the run list of the role, if it includes the `application` recipe.

You should also have a role for the environment(s) you wish to use this cookbook. Similar to the role above, create the Ruby DSL file in chef-repo, or create with knife directly.

    % knife role show production
    {
      "name": "production",
      "chef_type": "role",
      "json_class": "Chef::Role",
      "default_attributes": {
        "app_environment": "production"
      },
      "description": "production environment role",
      "run_list": [

      ],
      "override_attributes": {
      }
    }

This role uses a default attribute so nodes can be moved into other environments on the fly simply by modifying their node object directly on the Chef Server.

---
License and Author
==================

Author:: Adam Jacob (<adam@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)

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
