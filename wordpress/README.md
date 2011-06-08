Description
===========

Installs and configures Wordpress according to the instructions at http://codex.wordpress.org/Installing_WordPress. Does not set up a wordpress blog. You will need to do this manually by going to http://hostname/wp-admin/install.php (this URL may be different if you change the attribute values).

Changes
=======

### v0.8.2:

* [COOK-435] Don't set the mysql root user password in wordpress cookbook
* [COOK-535] - recursively create the directory
* RHEL/CentOS/Fedora support (yeah!)
* cleaned up node attribute keys
* cleaned up README.md

Requirements
============

Platform
--------

* Debian, Ubuntu
* RHEL, CentOS, Fedora

Tested on:

* Ubuntu 9.04, 9.10, 10.04
* Centos 5.5

Cookbooks
---------

* mysql
* php
* apache2
* opensssl (uses library to generate secure passwords)

Attributes
==========

* `node['wordpress']['version']` - Set the version to download.
* `node['wordpress']['checksum']` - sha256sum of the tarball, make sure this matches for the version!
* `node['wordpress']['dir']` - Set the location to place wordpress files. Default is /var/www.
* `node['wordpress']['db']['database']` - Wordpress will use this MySQL database to store its data.
* `node['wordpress']['db']['user']` - Wordpress will connect to MySQL using this user.
* `node['wordpress']['db']['password']` - Password for the Wordpress MySQL user. The default is a randomly generated string.

Attributes will probably never need to change (these all default to randomly generated strings):

* `node['wordpress']['keys']['auth']`
* `node['wordpress']['keys']['secure_auth']`
* `node['wordpress']['keys']['logged_in']`
* `node['wordpress']['keys']['nonce']`

The random generation is handled with the secure_password method in the openssl cookbook which is a cryptographically secure random generator and not predictable like the random method in the ruby standard library.

Usage
=====

If a different version than the default is desired, download that version and get the SHA256 checksum (sha256sum on Linux systems), and set the version and checksum attributes.

Add the "wordpress" recipe to your node's run list or role, or include the recipe in another cookbook.

Chef will install and configure mysql, php, and apache2 according to the instructions at http://codex.wordpress.org/Installing_WordPress. Does not set up a wordpress blog. You will need to do this manually by going to http://hostname/wp-admin/install.php (this URL may be different if you change the attribute values).

The mysql::server recipe needs to come first, and contain an execute resource to install mysql privileges from the grants.sql template in this cookbook.

## Note about MySQL

This cookbook will decouple the mysql::server and be smart about detecting whether to use a local database or find a database server in the environment in a later version.

License and Author
==================

Author:: Barry Steinglass (barry@opscode.com)
Author:: Joshua Timberman (joshua@opscode.com)
Author:: Seth Chisamore (schisamo@opscode.com)

Copyright:: 2010-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
