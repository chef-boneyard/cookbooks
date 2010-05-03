DESCRIPTION
===========

This cookbook is used to configure the system to be a Chef Client or a Chef Server. It is a complex cookbook, please read this entire document to understand how it works. For more information on how Chef itself works, see the [Chef Wiki](http://wiki.opscode.com)

The `bootstrap` cookbook's recipes for configuring a RubyGem installation of Chef have been merged into this cookbook.

    bootstrap::client -> chef::bootstrap_client
    bootstrap::server -> chef::bootstrap_server

REQUIREMENTS
============

Chef 0.8.x or higher is required.

Platform
--------

`chef::client` is tested on Ubuntu 8.04+, Debian 5.0, CentOS 5.x, Fedora 10+, OpenBSD 4.6, FreeBSD 7.1 and Gentoo.

`chef::bootstrap_client` is tested on the above. OpenSolaris 11 is also tested, but there's a bug in Ohai that requires some manual intervention (OHAI-122).

`chef::server` is tested on Ubuntu 8.04+, Debian 5.0.

`chef::bootstrap_server` is tested on Ubuntu 8.04+, Debian 5.0.

Client
------

`runit` cookbook is suggested for RubyGems installation. No other cookbooks are required for clients.

Server
------

The `chef::bootstrap_server` recipe uses the following other cookbooks from the Opscode repo.

    couchdb
    rabbitmq_chef
    openssl
    zlib
    xml
    java

The `chef::server_proxy` recipe uses the following cookbook:

* apache2

ATTRIBUTES
==========

The attributes for configuring the `chef` cookbook are under the `chef` namespace on the node, i.e., `@node[:chef]` or `@node.chef`.

umask
-----

Sets the umask for files created by the server process via `Chef::Config[:umask]` in `/etc/chef/server.rb`

url_type
--------

Set up the URLs the client should connect to with this. Default is `http`, which tells the client to connect to `http://server:4000`. If you set up your chef-server to use an SSL front-end for example with `chef::server_proxy`, set this to `https` for clients and the URLs will be `https://server/`.

By default the only URL config setting for Chef 0.8.x+ is `Chef::Config[:chef_server_url]`. The other older URLs are still supported so you can split out the various functions of the Chef Server, but configuration of those is outside the scope of this cookbook.

init_style
----------

Specifies the init style to use. Default `runit`. Other possible values `init`, `bsd`, any other string will be treated as unknown.

If your platform doesn't have a `runit` package or if the cookbook doesn't detect it, but you still want to use runit, set `init_style` to `none` and install runit separately.

path
----

This is the base location where Chef will store data and other artifacts. Default `/srv/chef` for RubyGems installed systems. If using Chef packages for your platform, the location preference varies. The default on Debian and Red Hat based systems is a filesystem hiearchy standard (FHS) suggestion. Some other locations you may consider, by platform:

Debian and Red Hat based Linux distros (Ubuntu, CentOS, Fedora, etc):

* `/var/lib/chef`

Any BSD and Gentoo:

* `/var/chef`

run_path
--------

Location for pidfiles on systems using init scripts. Default `/var/run/chef`.

If `init_style` is `init`, this is used, and should match what the init script itself uses for the PID files.

cache_path
----------

Location where the client will cache cookbooks and other data. Default is `cache` underneath the `chef[:path]` location. Linux distributions might prefer `/var/cache/chef` instead.

Base directory for data that is easily regenerated such as cookbook tarballs (`Chef::Config[:cookbook_tarballs]`) on the server, downloaded cookbooks on the client, etc. See the config templates.

serve_path
----------

Used by the Chef server as the base location to "serve" cookbooks, roles and other assets. Default is `/srv/chef`.

server_version
--------------

Version of Chef to install for the server. Used by the `server_proxy` recipe to set the location of the DocumentRoot of the WebUI.

client_version
--------------

Version of Chef to install for the client. Used to display a log message about the location of the init scripts when `init_style` is `init`, and can be used to upgrade `chef` gem with the `chef::bootstrap_client` recipe.

client_interval
---------------

Number of seconds to run chef-client periodically. Default `1800` (30 minutes).

client_splay
------------

Splay interval to randomly add to interval. Default `20`.

log_dir
-------

Directory where logs are stored if logs are not sent to STDOUT. Systems using runit should send logs to STDOUT as runit manages log output. Default STDOUT when `init_style` is `runit`, otherwise the default is `/var/log/chef`.

client_log, indexer_log, server_log
-----------------------------------

Location of the client, indexer and server logs, respectively. Default `STDOUT` on systems with runit, `/var/log/chef/{client,indexer,server}.log` on other systems.

Note that `chef-indexer` is deprecated for `chef-solr-indexer`.

server_port
-----------

Port for the Server API service to listen on. Default `4000`.

webui_port
----------

Port for the Server WebUI service to listen on. Default `4040`.

webui_enabled
-------------

As of version 0.8.x+, the WebUI part of the Chef Server is optional, and disabled by default. To enable it, set this to true.

webui_admin_password
--------------------

The default password in the `Chef::Config` is `p@ssw0rd1`, which may not be desirable. Change the webui `admin` user's password with this attribute. Note that this may require the `chef-server-webui` service be restarted an additional time, and it should still be changed on first login with the `admin` user.


server_fqdn
-----------

Fully qualified domain name of the server. Default is `chef.domain` where domain is detected by Ohai. You should configure a DNS entry for your Chef Server.

On servers, this specifies the URL the server expects to use by default `Chef::Config[:chef_server_url]`, plus it is used in the `server_ssl_req` as the canonical name (CN) and in `server_proxy` for the vhost name.

On clients, this specifies the URL the client uses to connect to the server as `Chef::Config[:chef_server_url]`.

server_ssl_req
--------------

Used by the `server_proxy` recipe, this attribute can be used to set up a self-signed SSL certificate automatically using OpenSSL. Fields:

* C: country (two letter code)
* ST: state/province
* L: locality or city
* O: organization
* OU: organizational unit
* CN: canonical name, usually the fully qualified domain name of the server (FQDN)
* emailAddress: contact email address

RECIPES AND USAGE
=================

This section describes the recipes in the cookbook and how to use them in your environment.

bootstrap_client
----------------

ONLY FOR RUBYGEMS INSTALLATIONS. Do not use this recipe if you installed Chef from packages for your platform.

Use this recipe to "bootstrap" a client so it can connect to a Chef Server. This recipe does the following:

* Ensures the gem installed matches the version desired (`client_version` attribute).
* Sets up the `chef-client` service depending on the `init_style` attribute (see above).
* Sets up some directories for Chef to use.
* Creates the client configuration file `/etc/chef/client.rb` based on the configuration passed via JSON.

Minimal JSON to use for the client configuration:

    {
      "chef": {
        "url_type": "http",
        "init_style": "runit",
        "server_port": "4000",
        "path": "/srv/chef",
        "server_fqdn": "localhost.localdomain",
      },
      "run_list": "recipe[chef::bootstrap_client]"
    }

This recipe is typically used with chef-solo. For more information see [Bootstrap Chef RubyGems Installation](http://wiki.opscode.com/display/chef/Bootstrap+Chef+RubyGems+Installation)

bootstrap_server
----------------

ONLY FOR RUBYGEMS INSTALLATIONS. Do not use this recipe if you installed Chef from packages for your platform.

Use this recipe to "bootstrap" a system to become a Chef Server. This recipe does the following:

* Includes the `chef::bootstrap_client` recipe to configure itself to be its own client.
* Installs CouchDB from package or source depending on the platform.
* Installs Java for the `chef-solr` search engine.
* Installs RabbitMQ (`rabbitmq_chef` cookbook) for the `chef-solr-indexer` consumer.
* Installs all the Server-related Gems.
* Creates the server configuration file `/etc/chef/server.rb` based on the configuration passed via JSON. 
* Sets up some directories for the server to use.
* Sets up the `chef-server`, `chef-solr`, `chef-solr-indexer` services depending on the `init_style` attribute (see above).

Minimal JSON to use for the client configuration:

    {
        "chef": {
          "url_type": "http",
          "init_style": "runit",
          "path": "/srv/chef",
          "server_port": "4000",
          "serve_path": "/srv/chef",
          "server_fqdn": "localhost.localdomain",
      },
      "run_list": "recipe[chef::bootstrap_server]"
    }

Note that the `chef-server-webui` is optional and can be enabled if desired by adding this to the JSON under "chef":

    "webui_enabled": true

See above about the `webui_admin_password` to use something other than the `Chef::Config` default.

This recipe is typically used with chef-solo. For more information see [Bootstrap Chef RubyGems Installation](http://wiki.opscode.com/display/chef/Bootstrap+Chef+RubyGems+Installation)

client
------

The client recipe is used to manage the configuration of an already-installed and configured Chef client. It can be used after a RubyGems installation bootstrap (per above), or with clients that were installed from platform packaging.

The recipe itself manages the `/etc/chef/client.rb` config file based on the attributes in this cookbook. When the client config is updated, the recipe will also reread the configuration during the Chef run, so the way Chef runs can be dynamically changed.

This recipe also deletes the validation certificate (default `/etc/chef/validation.pem`) if the client certificate file exists. If managing the config file isn't required by deleting the validation certificate is, see also the `chef::delete_validation` recipe below.

default
-------

There is no spoon.

delete_validation
-----------------

This is a standalone recipe that merely deletes the validation certificate (default `/etc/chef/validation.pem`). Use this if managing the client config file is not required in your environment.

server
------

server_proxy
------------

Sets up an Apache2 VirtualHost to proxy HTTPS for the Chef Server API and WebUI.

TEMPLATES
=========

LICENSE AND AUTHORS
===================

* Author: Joshua Timberman <joshua@opscode.com>
* Author: Joshua Sierles <joshua@37signals.com>

* Copyright 2008-2010, Opscode, Inc
* Copyright 2009, 37signals

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
