Description
===========

This cookbook provides a complete Debian/Ubuntu style Apache HTTPD configuration. Non-Debian based distributions such as Red Hat/CentOS, ArchLinux and others supported by this cookbook will have a configuration that mimics Debian/Ubuntu style as it is easier to manage with Chef.

Debian-style Apache configuration uses scripts to manage modules and sites (vhosts). The scripts are:

* a2ensite
* a2dissite
* a2enmod
* a2dismod

This cookbook ships with templates of these scripts for non Debian/Ubuntu platforms. The scripts are used in the __Definitions__ below.

Requirements
============

## Cookbooks:

This cookbook doesn't have direct dependencies on other cookbooks. Depending on your OS configuration and security policy, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following Operating System nuances may affect the behavior:

* apt cache outdated
* SELinux enabled
* IPtables
* Compile tools

On Ubuntu/Debian, use Opscode's `apt` cookbook to ensure the package cache is updated so Chef can install packages, or consider putting apt-get in your bootstrap process or [knife bootstrap template](http://wiki.opscode.com/display/chef/Knife+Bootstrap).

On RHEL, SELinux is enabled by default. The `selinux` cookbook contains a `permissive` recipe that can be used to set SELinux to "Permissive" state.

The easiest but certainly not ideal way to deal with IPtables is of course to flush all rules. Opscode does provide an `iptables` cookbook but is migrating from the approach used there to a more robust solution utilizing a general "firewall" LWRP that would have an "iptables" provider. Alternately, you can use ufw, with Opscode's `ufw` and `firewall` cookbooks to set up rules. See those cookbooks' READMEs for documentation.

Build/compile tools may not be installed on the system by default. Some recipes (e.g., `apache2::mode_auth_openid`) build the module from source. Use Opscode's `build-essential` cookbook to get essential build packages installed.

## Platforms:

* Debian
* Ubuntu
* Red Hat/CentOS/Scientific Linux/Fedora (RHEL Family)
* SUSE/OpenSUSE
* ArchLinux

### Notes for RHEL Family:

On Red Hat Enterprise Linux and derivatives, the EPEL repository may be necessary to install packages used in certain recipes. The `apache2::default` recipe, however, does not require any additional repositories. Opscode's `yum` cookbook contains a recipe to add the EPEL repository. See __Examples__ for more information.

Attributes
==========

This cookbook uses many attributes, broken up into a few different kinds.

Platform specific
-----------------

In order to support the broadest number of platforms, several attributes are determined based on the node's platform. See the attributes/default.rb file for default values in the case statement at the top of the file.

* `node['apache']['dir']` - Location for the Apache configuration
* `node['apache']['log_dir']` - Location for Apache logs
* `node['apache']['user']` - User Apache runs as
* `node['apache']['group']` - Group Apache runs as
* `node['apache']['binary']` - Apache httpd server daemon
* `node['apache']['icondir']` - Location for icons
* `node['apache']['cache_dir']` - Location for cached files used by Apache itself or recipes
* `node['apache']['pid_file']` - Location of the PID file for Apache httpd
* `node['apache']['lib_dir']` - Location for shared libraries

General settings
----------------

These are general settings used in recipes and templates. Default values are noted.

* `node['apache']['listen_ports']` - Ports that httpd should listen on. Default is an array of ports 80 and 443.
* `node['apache']['contact']` - Value for ServerAdmin directive. Default "ops@example.com".
* `node['apache']['timeout']` - Value for the Timeout directive. Default is 300.
* `node['apache']['keepalive']` - Value for the KeepAlive directive. Default is On.
* `node['apache']['keepaliverequests']` - Value for MaxKeepAliveRequests. Default is 100.
* `node['apache']['keepalivetimeout']` - Value for the KeepAliveTimeout directive. Default is 5.

Prefork attributes
------------------

Prefork attributes are used for tuning the Apache HTTPD prefork MPM configuration.

* `node['apache']['prefork']['startservers']` - initial number of server processes to start. Default is 16.
* `node['apache']['prefork']['minspareservers']` - minimum number of spare server processes. Default 16.
* `node['apache']['prefork']['maxspareservers']` - maximum number of spare server processes. Default 32.
* `node['apache']['prefork']['serverlimit']` - upper limit on configurable server processes. Default 400.
* `node['apache']['prefork']['maxclients']` - Maximum number of simultaneous connections.
* `node['apache']['prefork']['maxrequestsperchild']` - Maximum number of request a child process will handle. Default 10000.

Worker attributes
-----------------

Worker attributes are used for tuning the Apache HTTPD worker MPM configuration.

* `node['apache']['worker']['startservers']` - Initial number of server processes to start. Default 4
* `node['apache']['worker']['maxclients']` - Maximum number of simultaneous connections. Default 1024.
* `node['apache']['worker']['minsparethreads]` - Minimum number of spare worker threads. Default 64
* `node['apache']['worker']['maxsparethreads]` - Maximum number of spare worker threads. Default 192.
* `node['apache']['worker']['maxrequestsperchild']` - Maximum number of requests a child process will handle.

Recipes
=======

Most of the recipes in the cookbook are for enabling Apache modules. Where additional configuration or behavior is used, it is documented below in more detail.

The following recipes merely enable the specified module: `mod_alias`, `mod_basic`, `mod_digest`, `mod_authn_file`, `mod_authnz_ldap`, `mod_authz_default`, `mod_authz_groupfile`, `mod_authz_host`, `mod_authz_user`, `mod_autoindex`, `mod_cgi`, `mod_dav_fs`, `mod_dav_svn`, `mod_deflate`, `mod_dir`, `mod_env`, `mod_expires`, `mod_headers`, `mod_ldap`, `mod_log_config`, `mod_mime`, `mod_negotiation`, `mod_proxy`, `mod_proxy_ajp`, `mod_proxy_balancer`, `mod_proxy_connect`, `mod_proxy_http`, `mod_python`, `mod_rewrite`, `mod_setenvif`, `mod_status`, `mod_wsgi`, `mod_xsendfile`.

On RHEL Family distributions, certain modules ship with a config file with the package. The recipes here may delete those configuration files to ensure they don't conflict with the settings from the cookbook, which will use per-module configuration in `/etc/httpd/mods-enabled`.

default
-------

The default recipe does a number of things to set up Apache HTTPd.

mod\_auth\_openid
-----------------

This recipe compiles the module from source. In addition to `build-essential`, some other packages are included for installation like the GNU C++ compiler and development headers.

To use the module in your own cookbooks to authenticate systems using OpenIDs, specify an array of OpenIDs that are allowed to authenticate with the attribute `node['apache']['allowed_openids']`. Use the following in a vhost to protect with OpenID authentication:

    AuthOpenIDEnabled On
    AuthOpenIDDBLocation /var/cache/apache2/mod_auth_openid.db
    AuthOpenIDUserProgram /usr/local/bin/mod_auth_openid.rb

Change the DBLocation as appropriate for your platform. You'll need to change the file in the recipe to match. The UserProgram is optional if you don't want to limit access by certain OpenIDs.

mod\_fcgid
----------

Installs the fcgi package and enables the module. Requires EPEL on RHEL family.

On RHEL family, this recipe will delete the fcgid.conf and on version 6+, create the /var/run/httpd/mod_fcgid` directory, which prevents the emergency error:

    [emerg] (2)No such file or directory: mod_fcgid: Can't create shared memory for size XX bytes

mod\_php5
--------

Simply installs the appropriate package on Debian, Ubuntu and ArchLinux.

On Red Hat family distributions including Fedora, the php.conf that comes with the package is removed. On RHEL platforms less than v6, the `php53` package is used.

mod\_ssl
--------

Besides installing and enabling `mod_ssl`, this recipe will append port 443 to the `node['apache']['listen_ports']` attribute array and update the ports.conf.

god\_monitor
------------

Sets up a `god` monitor for Apache. External requirements are the `god` and `runit` cookbooks from Opscode.

Definitions
===========

The cookbook provides a few definitions. At some point in the future these definitions may be refactored into lightweight resources and providers.

apache\_conf
------------

Sets up configuration file for an Apache module from a template. The template should be in the same cookbook where the definition is used. This is used by the `apache_module` definition and is not often used directly.

This will use a template resource to write the module's configuration file in the `mods-available` under the Apache configuration directory (`node['apache']['dir']`). This is a platform-dependent location. See __apache\_module__.

### Parameters:

* `name` - Name of the template. When used from the `apache_module`, it will use the same name as the module.

### Examples:

Create `#{node['apache']['dir']}/mods-available/alias.conf`.

    apache_conf "alias"

apache\_module
--------------

Enable or disable an Apache module in `#{node['apache']['dir']}/mods-available` by calling `a2enmod` or `a2dismod` to manage the symbolic link in `#{node['apache']['dir']}/mods-enabled`. If the module has a configuration file, a template should be created in the cookbook where the definition is used. See __Examples__.

### Parameters:

* `name` - Name of the module enabled or disabled with the `a2enmod` or `a2dismod` scripts.
* `enable` - Default true, which uses `a2enmod` to enable the module. If false, the module will be disabled with `a2dismod`.
* `conf` - Default false. Set to true if the module has a config file, which will use `apache_conf` for the file.
* `filename` - specify the full name of the file, e.g.

### Examples:

Enable the ssl module, which also has a configuration template in `templates/default/ssl.conf.erb`.

    apache_module "ssl" do
      conf true
    end

Enable the php5 module, which has a different filename than the module default:

    apache_module "php5" do
      filename "libphp5.so"
    end

Disable a module:

    apache_module "disabled_module" do
      enable false
    end

See the recipes directory for many more examples of `apache_module`.

apache\_site
------------

Enable or disable a VirtualHost in `#{node['apache']['dir']}/sites-available` by calling a2ensite or a2dissite to manage the symbolic link in `#{node['apache']['dir']}/sites-enabled`.

The template for the site must be managed as a separate resource. To combine the template with enabling a site, see `web_app`.

### Parameters:

* `name` - Name of the site.
* `enable` - Default true, which uses `a2ensite` to enable the site. If false, the site will be disabled with `a2dissite`.

web\_app
--------

Manage a template resource for a VirtualHost site, and enable it with `apache_site`. This is commonly done for managing web applications such as Ruby on Rails, PHP or Django, and the default behavior reflects that. However it is flexible.

This definition includes some recipes to make sure the system is configured to have Apache and some sane default modules:

* `apache2`
* `apache2::mod_rewrite`
* `apache2::mod_deflate`
* `apache2::mod_headers`

It will then configure the template (see __Parameters__ and __Examples__ below), and enable or disable the site per the `enable` parameter.

### Parameters:

Current parameters used by the definition:

* `name` - The name of the site. The template will be written to `#{node['apache']['dir']}/sites-available/#{params[:name]}.conf`
* `cookbook` - Optional. Cookbook where the source template is. If this is not defined, Chef will use the named template in the cookbook where the definition is used.
* `template` - Default `web_app.conf.erb`, source template file. 
* `enable` - Default true. Passed to the `apache_site` definition.

Additional parameters can be defined when the definition is called in a recipe, see __Examples__.

### Examples:

All parameters are passed into the template. You can use whatever you like. The apache2 cookbook comes with a `web_app.conf.erb` template as an example. The following parameters are used in the template:

* `server_name` - ServerName directive.
* `server_aliases` - ServerAlias directive. Must be an array of aliases.
* `docroot` - DocumentRoot directive.
* `application_name` - Used in RewriteLog directive. Will be set to the `name` parameter.

To use the default web_app, for example:

    web_app "my_site" do
      server_name node['hostname']
      server_aliases [node['fqdn'], "my-site.example.com"]
      docroot "/srv/www/my_site"
    end

The parameters specified will be used as:

* `@params[:server_name]`
* `@params[:server_aliases]`
* `@params[:docroot]`

In the template. When you write your own, the `@` is significant.

For more information about Definitions and parameters, see the [Chef Wiki](http://wiki.opscode.com/display/chef/Definitions)

Usage
=====

Using this cookbook is relatively straightforward. Add the desired recipes to the run list of a node, or create a role. Depending on your environment, you may have multiple roles that use different recipes from this cookbook. Adjust any attributes as desired. For example, to create a basic role for web servers that provide both HTTP and HTTPS:

    % cat roles/webserver.rb
    name "webserver"
    description "Systems that serve HTTP and HTTPS"
    run_list(
      "recipe[apache2]",
      "recipe[apache2::mod_ssl]"
    )
    default_attributes(
      "apache2" => {
        "listen_ports" => ["80", "443"]
      }
    )

For examples of using the definitions in your own recipes, see their respective sections above.

Changes
=======

## v1.0.2

* Tickets resolved in this release: COOK-788, COOK-782, COOK-780

## v1.0.0

* Red Hat family support is greatly improved, all recipes except `god_monitor` converge.
* Recipe `mod_auth_openid` now works on RHEL family distros
* Recipe `mod_php5` will now remove config from package on RHEL family so it doesn't conflict with the cookbook's.
* Added `php5.conf.erb` template for `mod_php5` recipe.
* Create the run state directory for `mod_fcgid` to prevent a startup error on RHEL version 6.
* New attribute `node['apache']['lib_dir']` to handle lib vs lib64 on RHEL family distributions.
* New attribute `node['apache']['group']`.
* Scientific Linux support added.
* Use a file resource instead of the generate-module-list executed perl script on RHEL family.
* "default" site can now be disabled.
* web_app now has an "enable" parameter.
* Support for dav_fs apache module.
* Tickets resolved in this release: COOK-754, COOK-753, COOK-665, COOK-624, COOK-579, COOK-519, COOK-518
* Fix node references in template for a2dissite
* Use proper user and group attributes on files and templates.
* Replace the anemic README.rdoc with this new and improved superpowered README.md :).

License and Authors
===================

Author:: Adam Jacob <adam@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>
Author:: Bryan McLellan <bryanm@widemile.com>
Author:: Dave Esposito <esposito@espolinux.corpnet.local>
Author:: David Abdemoulaie <github@hobodave.com>
Author:: Edmund Haselwanter <edmund@haselwanter.com>
Author:: Eric Rochester <err8n@virginia.edu>
Author:: Jim Browne <jbrowne@42lines.net>
Author:: Matthew Kent <mkent@magoazul.com>
Author:: Nathen Harvey <nharvey@customink.com>
Author:: Ringo De Smet <ringo.de.smet@amplidata.com>
Author:: Sean OMeara <someara@opscode.com>
Author:: Seth Chisamore <schisamo@opscode.com>
Author:: Gilles Devaux <gilles@peerpong.com>

Copyright:: 2009-2011, Opscode, Inc
Copyright:: 2011, Atriso
Copyright:: 2011, CustomInk, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
