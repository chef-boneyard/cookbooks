Description
===========

Installs RadiantCMS, a Ruby on Rails content management system.

Requirements
============

Requires Chef 0.10.0

## Platform

The `db_bootstrap` recipe requires using the Opscode application cookbook.

Tested on Ubuntu 9.04, uses the Opscode Apache2 cookbook which is Ubuntu/Debian specific.

Requires Chef 0.7.12 for Deploy resource when installing from Radiant's git repo.

The `db_bootstrap` recipe requires Chef 0.9.10+ for the notifies resource syntax.

## Cookbooks

Opscode cookbooks (http://github.com/opscode/cookbooks/tree/master)

* git
* sqlite
* rails
* apache2
* passenger_apache2

Attributes
==========

* radiant[:edge] - Do a deploy from github repo if true, use gems if false, default false.
* radiant[:branch] - Branch to deploy from, default HEAD.
* radiant[:migrate] - Whether to do a database migration, default false.
* radiant[:migrate_command] - Command to do a database migration, default 'rake db:migrate'.
* radiant[:environment] - Rails environment to use, default is production.
* radiant[:revision] - Revision to deploy, default HEAD.
* radiant[:action] - Whether to deploy, rollback or nothing, default nothing.
* radiant[:db_bootstrap] - rake task to bootstrap a fresh database, use once and with care, it will delete the database contents.

Usage
=====

This recipe uses SQLite3 for the database by default. To set up the default database to get Radiant rolling, run a db:bootstrap by changing the radiant[:migrate] command to the following in the webui:

  yes | rake production db:bootstrap \
    ADMIN_NAME=Administrator \
    ADMIN_USERNAME=admin \
    ADMIN_PASSWORD=radiant \
    DATABASE_TEMPLATE=empty.yml

Change as required for your environment. If the target system doesn't have /usr/bin/yes, use echo 'yes' instead.

Radiant supports other database backends. We don't yet have automation ready to set up a database user and grant privileges, or creating the database itself.

## Database Bootstrap

This recipe is DESTRUCTIVE.

Normally when running the db:bootstrap rake task in Radiant, it prompts the user:

This task will destroy any data in the database. Are you sure you want to continue? [yn] y

This recipe wraps the rake db:bootstrap from above. Only use this recipe if you know what you are doing. Otherwise, run the db:bootstrap manually.

This recipe is designed to be used with the Opscode application cookbook, and only one time. It removes itself with a Ruby block resource when the rake resource executes successfully.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2009-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


