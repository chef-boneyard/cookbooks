Description
===========

Installs and configures Jira and starts it as a service under runit.

Changes
=======

## v0.8.2

* Current public release

Roadmap
-------

* [COOK-464] - Automate mysql portions

Requirements
============

## Platform:

* Ubuntu 10.04
* Debian 6.0

Requires a MySQL database server, but currently out of scope to run
this on the same system, or even automatically set it up (see
__Roadmap__ and __Usage__).

## Cookbooks:

* runit
* java
* apache2

Attributes
==========

See `attributes/default.rb` for defaults.

* `node['jira']['virtual_host_name']` - hostname to use in the virtualhost
* `node['jira']['virtual_host_alias']` - server alias(es) to use in
  the virtual host.
* `node['jira']['version']` - version of jira to install
* `node['jira']['install_path']` - location where jira should be installed
* `node['jira']['run_user']` - user to run the jira service as
* `node['jira']['database']` - the name of the database to connect to
* `node['jira']['database_host']` - hostname of the database server
* `node['jira']['database_user']` - user to connect to the database
* `node['jira']['database_password']` - password to use for the
  database connection.

Recipes
=======

default
-------

The default recipe sets up runit, java and apache2 first, then
downloads jira-standalone from atlassian of the specified version. It
also downloads and installs the mysql connector.

After writing the configuration and startup.sh script, jira will start
under runit, and an apache vhost will be set up for it.

Usage
=====

Until COOK-464 is released, the following manual steps are required to
set up the database.

Mysql queries:

    create database jiradb character set utf8;
    grant all privileges on jiradb.*
        to '$jira_user'@'localhost' identified by '$jira_password';
    flush privileges;

License and Author
==================

Author:: Adam Jacob <adam@opscode.com>

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
