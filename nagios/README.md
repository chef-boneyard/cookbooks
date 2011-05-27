Description
===========

Installs and configures Nagios 3 for a server and for clients using Chef search capabilities.

Changes
=======

## v1.0.0:

* Use Chef 0.10's `node.chef_environment` instead of `node['app_environment']`.
* source installation support on both client and server sides
* initial RHEL/CentOS/Fedora support

---
Requirements
============

Platform
--------

* Debian, Ubuntu
* RHEL, CentOS, Fedora

Tested on Ubuntu 10.04 and CentOS 5.5

Cookbooks
---------

* apache2
* build-essential
* php

Chef
----

Requires Chef 0.9.16+ for search capability of roles and data bags.

A data bag named 'users' should exist, see "DATA BAG" below.

The monitoring server that uses this recipe should have a role named 'monitoring' or similar. A "per-environment" role should be created as well. See "ROLES" below.

Because of the heavy use of search, this recipe will not work with Chef Solo, as it cannot do any searches without a server.

---
Attributes
==========

client
------

The following attributes are used for the client NRPE checks for warning and critical levels.

* `node['nagios']['checks']['memory']['critical']`
* `node['nagios']['checks']['memory']['warning']`
* `node['nagios']['checks']['load']['critical']`
* `node['nagios']['checks']['load']['warning']`
* `node['nagios']['checks']['smtp_host']` - default relayhost to check for connectivity. Default is an empty string, set via an attribute in a role.
* `node['nagios']['server_role']` - the role that the nagios server will have in its run list that the clients can search for.

The file also contains the following attribute types:

* platform specific locations and settings.
* plugin and nrpe source installation settings

server
------

* `node['nagios']['notifications_enabled']` - set to 1 to enable notification.
* `node['nagios']['check_external_commands']`
* `node['nagios']['default_contact_groups']`
* `node['nagios']['sysadmin_email']` - default notification email.
* `node['nagios']['sysadmin_sms_email']` - default notification sms.
* `node['nagios']['server_auth_method']` - authentication with the server can be done with openid (using apache2::mod_auth_openid), or htauth (basic). The default is openid, any other value will use htauth (basic).
* `node['nagios']['templates']`
* `node['nagios']['interval_length']` - minimum interval.
* `node['nagios']['default_host']['check_interval']`
* `node['nagios']['default_host']['retry_interval']`
* `node['nagios']['default_host']['max_check_attempts']`
* `node['nagios']['default_host']['notification_interval']`
* `node['nagios']['default_service']['check_interval']`
* `node['nagios']['default_service']['retry_interval']`
* `node['nagios']['default_service']['max_check_attempts']`
* `node['nagios']['default_service']['notification_interval']`

The file also contains the following attribute types:

* platform specific locations and settings.
* server source installation settings


---
Recipes
=======

default
-------

Includes the `nagios::client` recipe.

client
------

Includes the correct client installation recipe based on platform, either `nagios::client_package` or `nagios::client_source`.

The client recipe searches for allowed servers via a role named 'monitoring'. The recipe will also install the required packages and start the NRPE service. A custom plugin for checking memory is also added.

Client commands for NRPE can be modified by editing the nrpe.cfg.erb template.

client_package
--------------

Installs the Nagios client libraries from packages.

client_source
-------------

Installs the Nagios client libraries from source.

server
------

Includes the correct client installation recipe based on platform, either `nagios::server_package` or `nagios::server_source`.

The server recipe sets up Apache as the web front end. The nagios::client recipe is also included. This recipe also does a number of searches to dynamically build the hostgroups to monitor, hosts that belong to them and admins to notify of events/alerts.

The recipe does the following:

1. Searches for members of the sysadmins group by searching through 'users' data bag and adds them to a list for notification/contacts.
2. Search all nodes for a role matching the app_environment.
3. Search all available roles and build a list which will be the Nagios hostgroups.
4. Search for all nodes of each role and add the hostnames to the hostgroups.
5. Installs various packages required for the server.
6. Sets up some configuration directories.
7. Moves the package-installed Nagios configuration to a 'dist' directory.
8. Disables the 000-default site (present on Debian/Ubuntu Apache2 package installations).
9. Enables the Nagios web front end configuration.
10. Sets up the configuration templates for services, contacts, hostgroups and hosts.

*NOTE*: You will probably need to change the services.cfg.erb template for your environment.

To add custom commands for service checks, these can be done on a per-role basis by editing the 'services.cfg.erb' template. This template has some pre-configured checks that use role names used in an example infrastructure. Here's a brief description:

* monitoring - check_smtp (e.g., postfix relayhost) w/ NRPE and tcp port 514 (e.g., rsyslog)
* load_balancer - check_nginx with NRPE.
* appserver - check_unicorn with NRPE, e.g. a Rails application using Unicorn.
* database_master - check_mysql_server with NRPE for a MySQL database master.

server_package
--------------

Installs the Nagios server libraries from packages.

server_source
-------------

Installs the Nagios server libraries from source.


---
Data Bags
=========

Create a `users` data bag that will contain the users that will be able to log into the Nagios webui. Each user can use htauth with a specified password, or an openid. Users that should be able to log in should be in the sysadmin group. Example user data bag item:

    {
      "id": "nagiosadmin",
      "groups": "sysadmin",
      "htpasswd": "hashed_htpassword",
      "openid": "http://nagiosadmin.myopenid.com/",
      "nagios": {
        "pager": "nagiosadmin_pager@example.com",
        "email": "nagiosadmin@example.com"
      }
    }

When using server_auth_method 'openid', use the openid in the data bag item. Any other value for this attribute (e.g., "htauth", "htpasswd", etc) will use the htpasswd value as the password in `/etc/nagios3/htpasswd.users`.

The openid must have the http:// and trailing /. The htpasswd must be the hashed value. Get this value with:

    % htpasswd -n nagiosadmin
    New password:
    Re-type new password:
    nagiosadmin:mbfzZrHsUUjds

For example use the "mbfzZrHsUUjds" value in the data bag.


---
Roles
=====

Create a role to use for the monitoring server. The role name should match the value of the attribute "nagios[:server_role]". By default, this is 'monitoring'. For example:

    % cat roles/monitoring.rb
    name "monitoring"
    description "Monitoring server"
    run_list(
      "recipe[nagios::server]"
    )

    default_attributes(
      "nagios" => {
        "server_auth_method" => "htauth"
      }
    )

Also create per-environment role. For example, production nodes:

    % cat roles/production.rb
    name "production"
    description "Nodes in the production environment."
    default_attributes(
      "app_environment" => "production"
    )

Make sure to apply the production role to all nodes that should be monitored by the production monitoring server.

---
Definitions
===========

nagios_conf
-----------

This definition is used to drop in a configuration file in the base Nagios configuration directory's conf.d. This can be used for customized configurations for various services.

---
Libraries
=========

default
------- 

The library included with the cookbook provides some helper methods used in templates.

* nagios_boolean
* nagios_interval - calculates interval based on interval length and a given number of seconds.
* nagios_attr - retrieves a nagios attribute from the node.


---
Usage
=====

For a Nagios server, create a role named 'monitoring', and add the following recipe to the run_list:

    recipe[nagios::server]

This will allow client nodes to search for the server by this role and add its IP address to the allowed list for NRPE.

To install Nagios and NRPE on a client node:

    include_recipe "nagios::client"

This is a fairly complicated cookbook. For a walkthrough and example usage please see [Opscode's Nagios Quick Start](http://help.opscode.com/kb/otherhelp/nagios-quick-start).

---
License and Author
==================

Author:: Joshua Sierles <joshua@37signals.com>
Author:: Nathan Haneysmith <nathan@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>
Author:: Seth Chisamore <schisamo@opscode.com>

Copyright 2009, 37signals
Copyright 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
