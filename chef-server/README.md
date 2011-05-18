IMPORTANT CHANGES
=================

Please note the following important changes to the Chef cookbook(s) that coincide with the 0.10 release of Chef.

Cookbook Renaming
-----------------

The cookbook formerly known as 'chef' has been split into two cookbooks:

* chef-client
* chef-server

So users have a clearer distinction about where to find recipes for managing Chef itself. The `chef` cookbook will still be available for backwards compatibility reasons.

Attributes
----------

The attributes are namespaced between using `chef_client` and `chef_server`. Several attributes have been renamed completely. See the attributes section below.

Paths
-----

Path default values are selected by Platform according to the various distributions "best practice" preference. For example, major Linux distributions use the Filesystem Hierarchy Standard, which the attributes attempt to mimic. See the various platform specific path attributes in the attributes section.

Init Style
----------

The default init style is chosen based on the platform. See the usage section on choosing an init style below.

Recipes
-------

The recipes in the chef cookbook that are now in chef-server:

    chef::bootstrap_server -> chef-server::rubygems-install
    chef::server -> chef-server::default
    chef::server_proxy -> chef-server::apache-proxy

See the recipes section below.

DESCRIPTION
===========

This cookbook is used to configure a system to be a Chef Server. It has a few recipes, please read the recipes section below for information on what each one is used for.

REQUIREMENTS
============

Chef 0.10.0 or later is required. For earlier versions of Chef, see the `chef` cookbook, version 0.99.0.

Platform
--------

The Chef Server will work on a variety of platforms, however a Ubuntu or Debian is recommended when performing a RubyGems installation. Other platforms may work but are not as well tested.

The `chef-server::default` recipe will work on any platform running the Chef Server, as it only compacts the CouchDB / views.

Cookbooks
---------

The chef-server cookbook requires the following cookbooks from Opscode. Some are required for various init style options (bluepill, runit, daemontools):

* apt
* apache2
* runit
* couchdb
* chef-client
* chef-server
* openssl
* gecode
* java
* xml
* zlib
* erlang
* bluepill
* daemontools
* ucspi-tcp
* build-essential

ATTRIBUTES
==========

The attributes used by this cookbook are under the `chef_server` namespace.

When using the rubygems-install recipe, set the desired attributes using a JSON file. See __RUBYGEMS_INSTALLATION__ for more information.

Platform Specific Attributes
----------------------------

The following attributes are chosen based on the platform and set accordingly. See the attributes/default.rb for default values by platform. The following platforms are supported:

* arch
* debian
* ubuntu
* redhat
* centos
* fedora
* openbsd
* freebsd
* mac\_os\_x

### init\_style

This attribute is used by the `chef-server::rubygems-install` recipe. This specifies the type of init system used on the Chef Server. The attributes file will choose an init style based on the platform, but this can be overriden by specifying an alternate value.

Automatically determined values:

* arch - ArchLinux, and uses the appropriate rc.d and conf.d scripts out of the `chef` gem.
* init - Debian, Ubuntu, Red Hat, CentOS and Fedora. Uses the appropriate /etc/default, /etc/sysconfig and /etc/init.d files out of the `chef` gem.
* bsd - OpenBSD, FreeBSD and Mac OS X, does not actually set up any system startup daemon, but provides a log message for the administrator of further hints.

The following alternate init styles are available as well.

* runit - sets up the daemons and logging in /etc/sv/SERVICE with Opscode's `runit` cookbook.
* daemontools - sets up the daemons and logging in /etc/sv/SERVICE with Opscode's `daemontools` cookbook.
* bluepill - sets up the daemons in /etc/bluepill/SERVICE with Opscode's `bluepill` cookbook.

This cookbook does not yet support Upstart for Ubuntu/Debian, but that is planned for a future release, and will be specified via this attribute.

### path

Used for the `chef` user's home directory.

### run\_path

Location for PID files on systems using init scripts.

If `init_style` is `init`, this is used, and should match what the init script itself uses for the PID files.

### cache\_path

Location where the client will cache cookbooks and other data. Corresponds to `Chef::Config[:file_cache_path]` configuration value.

### backup\_path

Location where backups of files replaced by Chef (template, `cookbook_file`, etc), corresponds to the `Chef::Config[:file_backup_path]` location.

Non-platform Specific Attributes
--------------------------------

### umask

Sets the umask for files created by the server process via `Chef::Config[:umask]` in `/etc/chef/server.rb`

### url

Full URI for the Chef Server. Used by `Chef::Config[:chef_server_url]` configuration setting. Default is http://localhost:4000. If running chef-solr on a separate machine, configure it to the appropriate network accessible URL (e.g., http://chef.example.com:4000).

### log\_dir

Location where logs should be stored when initializing services via init scripts. Not used if init style is runit, daemontools or bluepill.

### api\_port

Port for the Server API service to listen on. Default `4000`.

### webui\_port

Port for the Server WebUI service to listen on. Default `4040`.

### webui\_enabled

As of version 0.8.x+, the WebUI part of the Chef Server is optional, and disabled by default. To enable it, set this to true.

### solr\_heap\_size

Sets the amount of memory for the SOLR heap, default 256M.

### validation\_client\_name

Set the name of the special client used to validate new clients. Default `chef-validator`.

### expander\_nodes

Number of nodes to start up for the chef-expander (replacement for chef-solr-indexer in 0.10). Default is 1.

Server Proxy Attributes
-----------------------

The following attributes are used by the `apache-proxy.rb` recipe, and are stored in the `apache-proxy.rb` attributes file. They are under the `node['chef_server']` attribute space.

doc\_root
---------

DocumentRoot for the WebUI. Also gets set in the vhost for the API, but it is not used since the vhost merely proxies to the server on port 4000.

ssl\_req
--------

This attribute can be used to set up a self-signed SSL certificate automatically using OpenSSL. Fields:

* C: country (two letter code)
* ST: state/province
* L: locality or city
* O: organization
* OU: organizational unit
* CN: canonical name, usually the fully qualified domain name of the server (FQDN)
* emailAddress: contact email address

This attribute should be a single string, fields separated by /.

css\_expire\_hours
------------------

Sets expiration time for CSS in the WebUI.

js\_expire\_hours
-----------------

Sets expiration time for JavaScript in the WebUI.

RECIPES AND USAGE
=================

This section describes the recipes in the cookbook and how to use them in your environment. This is focused on the Chef Server itself. To set up a Chef Server that will also be a Chef Client to itself, see the `chef-client` cookbook.

default
-------

Since the Chef Server itself typically runs the CouchDB service for the data store, the recipe will do a compaction on the Chef database and all the views associated with the Chef Server. These compactions only occur if the database/view size is more than 100Mb. It will use the configured CouchDB URL, which is `http://localhost:5984` by default. The actual value used for the CouchDB server is from the `Chef::Config[:couchdb_url]`, so this can be dynamically changed in the /etc/chef/server.rb config file.

apache-proxy
------------

This recipe sets up an Apache2 VirtualHost to proxy HTTPS for the Chef Server API and WebUI.

The API will be proxied on port 443. If the WebUI is enabled, it will be proxied on port 444. The recipe dynamically creates the OpenSSL certificate based on the `node['chef_server']['ssl_req']` attribute. It uses additional configuration for Apache to improve performance of the webui. The virtual host template is `chef_server.conf.erb`. The DocumentRoot setting is used for the WebUI, but not the API, and is set with the attribute `node['chef_server']['doc_root']`.

rubygems-install
----------------

ONLY FOR RUBYGEMS INSTALLATIONS. Do not use this recipe if you installed Chef from packages for your platform.

Use this recipe to "bootstrap" a system to become a Chef Server. This recipe does the following:

* Creates a `chef` user.
* Installs CouchDB from package or source depending on the platform.
* Installs Java for the `chef-solr` search engine.
* Installs RabbitMQ with the `chef-server::rabbitmq` recipe for the chef-expander consumer.
* Installs Gecode with the `gecode` cookbook. On Debian/Ubuntu, Opscode's APT repository will be used. On other platforms, Gecode will be installed from source, which can take a long time.
* Installs all the Server-related RubyGems.
* Creates the server configuration file `/etc/chef/server.rb` based on the configuration passed via JSON.
* Creates the chef-solr configuration file, `/etc/chef/solr.rb`.
* Sets up the `chef-server`, `chef-solr`, `chef-expander` services depending on the `init_style` attribute (see above).

Minimal JSON to use for the server configuration:

    {
      "chef_server": {
        "url": "http://localhost.localdomain:4000",
      },
      "run_list": "recipe[chef-server::rubygems-install]"
    }

Note that the `chef-server-webui` is optional and can be enabled if desired.

    {
      "chef_server": {
        "url": "http://localhost.localdomain:4000",
        "webui_enabled": true
      },
      "run_list": "recipe[chef-server::rubygems-install]"
    }

For more information see [Bootstrap Chef RubyGems Installation](http://wiki.opscode.com/display/chef/Bootstrap+Chef+RubyGems+Installation) on the Chef Wiki and the attributes section above.

TEMPLATES
=========

chef\_server.conf.erb
---------------------

VirtualHost file used by Apache2 in the `chef-server::apache-proxy` recipe.

server.rb.erb
-------------

Configuration for the server and server components used in the `chef-server::rubygems-install` recipe.

solr.rb.erb
-----------

Configuration for chef-solr used in the `chef-server::rubygems-install` recipe.

sv-\*run.erb
-------------

Runit and daemontools "run" scripts for the services configured when `node['chef_server']['init_style']` is "runit" or "daemontools".

\*.pill.erb
-----------

Bluepill "pill" files for the services configured when `node['chef_server']['init_style']` is "bluepill".

LICENSE AND AUTHORS
===================

* Author: Joshua Timberman <joshua@opscode.com>
* Author: Joshua Sierles <joshua@37signals.com>

* Copyright 2008-2011, Opscode, Inc
* Copyright 2009, 37signals

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
