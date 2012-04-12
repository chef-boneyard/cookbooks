Description
===========

Installs and configures Jira and starts it as a service under runit.

Requirements
============

## Platform:

* Ubuntu 11.10
* Debian 6.0

Requires a MySQL database server, but currently out of scope to run
this on the same system, or even automatically set it up (see
__Roadmap__ and __Usage__).

## Cookbooks:

* runit
* java
* apache2
* mysql

Attributes
==========

See `attributes/default.rb` for defaults.

* `node['jira']['virtual_host_name']` - hostname to use in the virtualhost
* `node['jira']['virtual_host_alias']` - server alias(es) to use in
  the virtual host.
* `node['jira']['version']` - version of jira to install
* `node['jira']['install_path']` - location where jira should be installed
* `node[:jira']['run_user']` - user to run the jira service as
* `node[:jira][:home]` - required to run Jira

Recipes
=======

default
-------

The default recipe sets up mysql, runit, java and apache2 first, then
downloads jira-standalone from atlassian of the specified version. It
also downloads and installs the mysql connector.

After writing the configuration and startup.sh script, jira will start
under runit, and an apache vhost will be set up for it.

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
