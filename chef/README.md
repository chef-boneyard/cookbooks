BOOTSTRAP CHANGES
=================

The `bootstrap` cookbook's recipes for configuring a RubyGem installation of Chef have been merged into this cookbook.

    bootstrap::client -> chef::bootstrap_client
    bootstrap::server -> chef::bootstrap_server

Be aware of the following changes to this cookbook.

* Bootstrap no longer generates a random password for the webui admin user. The default password is displayed on the webui login page and should be changed immediately after logging in.
* Server configuration now has a setting for the cookbook tarballs. See the server.rb.erb template.
* We now set the signing key/cert locations and set owner / group. See the server.rb.erb template.
* The validation client name is configurable. See the attributes.

DESCRIPTION
===========

This cookbook is used to configure the system to be a Chef Client or a Chef Server. It is a complex cookbook, please read this entire document to understand how it works. For more information on how Chef itself works, see the [Chef Wiki](http://wiki.opscode.com)

REQUIREMENTS
============

Chef 0.8.16 or later is required.

Chef 0.9.0 or later is required to use the `chef.init_style` attribute value `init`, in order to have the init scripts available.

Platform
--------

If using this cookbook to manage a Chef Server system that was installed from Debian/Ubuntu packages, note that in the packages, the configuration files are split up for server.rb, solr.rb and webui.rb, and the `chef::server` recipe may not work as desired.

We recommend using a recent version of Ubuntu or Debian for the Chef Server.

* Ubuntu 9.10/10.04
* Debian testing/unstable

These versions have newer versions of CouchDB and RabbitMQ packaged.

`chef::client` is tested on Ubuntu 8.04+, Debian 5.0, CentOS 5.x, Fedora 10+, OpenBSD 4.6, FreeBSD 7.1 and Gentoo.

`chef::bootstrap_client` is tested on the above. OpenSolaris 11 is also tested, but there's a bug in Ohai that requires some manual intervention (OHAI-122).

`chef::server` is tested on Ubuntu 8.04+, Debian 5.0.

`chef::bootstrap_server` is tested on Ubuntu 8.04+, Debian 5.0.

Client
------

`runit` cookbook is suggested for RubyGems installation. No other cookbooks are required for clients.

Server
------

The `chef::bootstrap_server` recipe uses the following other cookbooks from the Opscode repository.

* couchdb
* `rabbitmq_chef`
* openssl
* zlib
* xml
* java

The `chef::server_proxy` recipe uses the following cookbook:

* apache2

ATTRIBUTES
==========

The attributes for configuring the `chef` cookbook are under the `chef` namespace on the node, i.e., `@node[:chef]` or `@node.chef`.

When using the bootstrap recipe, set the desired attributes using a JSON file. See "BOOTSTRAPPING" for examples.

umask
-----

Sets the umask for files created by the server process via `Chef::Config[:umask]` in `/etc/chef/server.rb`

url_type
--------

Set up the URLs the client should connect to with this. Default is `http`, which tells the client to connect to `http://server:4000`. If you set up your chef-server to use an SSL front-end for example with `chef::server_proxy`, set this to `https` for clients and the URLs will be `https://server/`.

By default the only URL config setting for Chef 0.8.x+ is `Chef::Config[:chef_server_url]`. The other older URLs are still supported so you can split out the various functions of the Chef Server, but configuration of those is outside the scope of this cookbook.

init_style
----------

Specifies the init style to use. Default `runit`. Other possible values `init`, `bsd`, any other string will be treated as unknown and a message will be displayed during the Chef run.

If your platform doesn't have a `runit` package or if the cookbook doesn't detect it, but you still want to use runit, set `init_style` to `none` and install runit separately. You may need to configure the runit services separately.

Using the `init` value for this attribute will retrieve the init scripts that are distributed with the Chef gem. 

This cookbook does not yet support Upstart for Ubuntu/Debian, but that is planned for a future release, and will be specified via this attribute.

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

Location where the client will cache cookbooks and other data. Default is `cache` underneath the `chef[:path]` location. Linux distributions adhering to the FHS prefer `/var/cache/chef` instead.

Base directory for data that is easily regenerated such as cookbook tarballs (`Chef::Config[:cookbook_tarballs]`) on the server, downloaded cookbooks on the client, etc. See the config templates.

backup_path
-----------

Location where backups of files, corresponds to the `file_backup_path` location. Defaults to `backup` under `chef[:path]` location. Set to `false` to use the old behavior which stores the backup files in the same directory as the target.

FHS location suggestion: `/var/lib/chef/backup`.

serve_path
----------

Used by the Chef server as the base location to "serve" cookbooks, roles and other assets. Default is `/srv/chef`.

server_version
--------------

Version of Chef to install for the server. Used by the `server_proxy` recipe to set the location of the DocumentRoot of the WebUI. Automatically determined via ohai's `chef_packages[:chef][:version]` by default.

client_version
--------------

Version of Chef to install for the client. Used to display a log message about the location of the init scripts when `init_style` is `init`, and can be used to upgrade `chef` gem with the `chef::bootstrap_client` recipe. Automatically determined via ohai's `chef_packages[:chef][:version]` by default.

client_interval
---------------

Number of seconds to run chef-client periodically. Default `1800` (30 minutes).

client_splay
------------

Splay interval to randomly add to interval. Default `20`.

log_dir
-------

When `init_style` is `init`, this directory needs to be created. The default is `/var/log/chef`.

client_log, indexer_log, server_log
-----------------------------------

These options are deprecated to reduce complexity and potential confusion.

server_port
-----------

Port for the Server API service to listen on. Default `4000`.

webui_port
----------

Port for the Server WebUI service to listen on. Default `4040`.

webui_enabled
-------------

As of version 0.8.x+, the WebUI part of the Chef Server is optional, and disabled by default. To enable it, set this to true.

server_fqdn
-----------

Fully qualified domain name of the server. Default is `chef.domain` where domain is detected by Ohai. You should configure a DNS entry for your Chef Server.

On servers, this specifies the URL the server expects to use by default `Chef::Config[:chef_server_url]`, plus it is used in the `server_ssl_req` as the canonical name (CN) and in `server_proxy` for the vhost name.

On clients, this specifies the URL the client uses to connect to the server as `Chef::Config[:chef_server_url]`.

server_url
----------

Full URI for the Chef Server. Used for `chef_server_url` config setting. The default value combines the attributes `chef.url_type`, `chef.server_fqdn` and `chef.server_port`, creating for example "http://chef.example.com:4000". If you are using the Opscode Platform, set this to "https://api.opscode.com/organizations/ORGNAME", where ORGNAME is your organization's simple string name.

SERVER PROXY
------------

The following attributes are used by the `server_proxy.rb` recipe, and are stored in the `server_proxy.rb` attributes file.

doc_root
--------

DocumentRoot for the WebUI. Also gets set in the vhost for the API, but it is not used since the vhost merely proxies to the server on port 4000.

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

This attribute is now in the `server_proxy.rb` attributes file, as it is specific to that context.

server_proxy.css_expire_hours
-----------------------------

Sets expiration time for CSS in the WebUI.

server_proxy.js_expire_hours
----------------------------

Sets expiration time for JavaScript in the WebUI.

RECIPES AND USAGE
=================

This section describes the recipes in the cookbook and how to use them in your environment.

BOOTSTRAPPING
-------------

The first two recipes described are for "bootstrapping" a system to be a Chef Client or Chef Server, respectively. Only use these recipes with RubyGems installations of Chef.

These recipes are typically used with chef-solo using a JSON file of attributes and a run list, and a solo config file. For more information see [Bootstrap Chef RubyGems Installation](http://wiki.opscode.com/display/chef/Bootstrap+Chef+RubyGems+Installation) on the Chef Wiki.

bootstrap_client
----------------

ONLY FOR RUBYGEMS INSTALLATIONS. Do not use this recipe if you installed Chef from packages for your platform.

Use this recipe to "bootstrap" a client so it can connect to a Chef Server. This recipe does the following:

* Ensures the gem installed matches the version desired (`client_version` attribute).
* Sets up the `chef-client` service depending on the `init_style` attribute (see above).
* Sets up some directories for Chef to use.
* Creates the client configuration file `/etc/chef/client.rb` based on the configuration passed via JSON.

For configuring a new client to connect to the Opscode Platform:

    {
      "chef": {
        "server_url": "https://api.opscode.com/organizations/ORGNAME"
      },
      "run_list": "recipe[chef::bootstrap_client]"
    }

For configuring a new client to connect to a local Chef Server:

    {
      "chef": {
        "server_url": "http://chef.example.com:4000"
      },
      "run_list": "recipe[chef::bootstrap_client]"
    }

This is the minimal JSON to use for the client configuration. See the ATTRIBUTES section above for more options.

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

Minimal JSON to use for the server configuration:

    {
      "chef": {
        "server_url": "http://localhost.localdomain:4000",
      },
      "run_list": "recipe[chef::bootstrap_server]"
    }

Note that the `chef-server-webui` is optional and can be enabled if desired by adding this to the JSON under "chef":

    "webui_enabled": true

client
------

The client recipe is used to manage the configuration of an already-installed and configured Chef client. It can be used after a RubyGems installation bootstrap (per above), or with clients that were installed from platform packaging.

The recipe itself manages the `/etc/chef/client.rb` config file based on the attributes in this cookbook. When the client config is updated, the recipe will also reread the configuration during the Chef run, so the current Chef run can be dynamically changed.

This recipe does not manage the `chef-client` service. It is assumed to have been set up and started from the `bootstrap_client` recipe above, or from OS / distribution packaging. The `chef-client` service should not be restarted as a result of `/etc/chef/client.rb` changing, as that can cause the current process running the client to be restarted, having unpredictable results.

default
-------

There is no spoon :-).

delete_validation
-----------------

This is a standalone recipe that merely deletes the validation certificate (default `/etc/chef/validation.pem`). Use this if managing the client config file is not required in your environment.

Beware if using this on your Chef Server. First copy the validation.pem certificate file to another location, such as your knife configuration directory (`~/.chef`) or [Chef Repository](http://wiki.opscode.com/display/chef/Chef+Repository).

server
------

The server recipe includes the `chef::client` recipe above.

The recipe itself manages the services and the Server config file `/etc/chef/server.rb`. See above under Platform requirements for cavaet when running Chef Server installed via Debian/Ubuntu packages. Changes to the recipe to manage additional templates may be required.

The following services are managed:

* chef-solr
* chef-solr-indexer
* chef-server
* chef-webui (if installed)

Changes to the `/etc/chef/server.rb` will trigger a restart of these services.

Since the Chef Server itself typically runs the CouchDB service for the data store, the recipe will do a compaction on the Chef database and all the views associated with the Chef Server. These compactions only occur if the database/view size is more than 100Mb. It will use the configured CouchDB URL, which is `http://localhost:5984` by default. The actual value used for the CouchDB server is from the `Chef::Config[:couchdb_url]`, so this can be dynamically changed.

server_proxy
------------

This recipe sets up an Apache2 VirtualHost to proxy HTTPS for the Chef Server API and WebUI.

The API will be proxied on port 443. If the `chef-serer-webui` is installed, it will be proxied on port 444. The recipe dynamically creates the OpenSSL certificate based on the `chef.server_ssl_req` attribute. It uses some additional configuration for Apache to improve performance of the webui. The virtual host template is `chef_server.conf.erb`. The DocumentRoot setting is used for the WebUI, but not the API, and is set with the attribute `chef.doc_root`.

TEMPLATES
=========

chef_server.conf.erb
--------------------

VirtualHost file used by Apache2 in the `chef::server_proxy` recipe.

client.rb.erb
-------------

Configuration for the client, lands in `/etc/chef/client.rb`.

server.rb.erb
-------------

Configuration for the server and server components, lands in `/etc/chef/server.rb`. See above regarding Debian/Ubuntu packaging config files when using packages to install Chef.

sv-*run.erb
-----------

Various runit "run" scripts for the Chef services that get configured when `init_style` is "runit".

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
