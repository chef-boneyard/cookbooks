Description
===========

This cookbook is used to configure a system as a Chef Client.

Requirements
============

Chef 0.9.12 or higher is required.

Platforms
---------

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error.

* Debian
* Ubuntu
* Red Hat
* CentOS
* Fedora
* ArchLinux
* FreeBSD
* Mac OS X

Opscode Cookbooks
-----------------

Other cookbooks can be used with this cookbook but they are not explicitly required. The default settings in this cookbook do not require their use. The other cookbooks (on community.opsocde.com) are:

* bluepill
* daemontools
* runit

See __USAGE__ below.

Attributes
==========

* `node["chef_client"]["interval"]` - Sets `Chef::Config[:interval]` via command-line option for number of seconds between chef-client daemon runs. Default 1800.
* `node["chef_client"]["splay"]` - Sets `Chef::Config[:splay]` via command-line option for a random amount of seconds to add to interval. Default 20.
* `node["chef_client"]["log_dir"]` - Sets directory used in `Chef::Config[:log_location]` via command-line option to a location where chef-client should log output. Default "/var/log/chef".
* `node["chef_client"]["conf_dir"]` - Sets directory used via command-line option to a location where chef-client search for the client config file . Default "/etc/chef".
* `node["chef_client"]["bin"]` - Sets the full path to the `chef-client` binary.  Mainly used to set a specific path if multiple versions of chef-client exist on a system or the bin has been installed in a non-sane path. Default "/usr/bin/chef-client"
* `node["chef_client"]["server_url"]` - Sets `Chef::Config[:chef_server_url]` in the config file to the Chef Server URI. Default "http://localhost:4000". See __USAGE__.
* `node["chef_client"]["validation_client_name"]` - Sets `Chef::Config[:validation_client_name]` in the config file to the name of the validation client. Default "chef-validator". See __USAGE__.
* `node["chef_client"]["init_style"]` - Sets up the client service based on the style of init system to use. Default is based on platform and falls back to "none". See __USAGE__.
* `node["chef_client"]["run_path"]` - Directory location where chef-client should write the PID file. Default based on platform, falls back to "/var/run".
* `node["chef_client"]["cache_path"]` - Directory location for `Chef::Config[:file_cache_path]` where chef-client will cache various files. Default is based on platform, falls back to "/var/chef/cache".
* `node["chef_client"]["backup_path"]` - Directory location for `Chef::Config[:file_backup_path]` where chef-client will backup templates and cookbook files. Default is based on platform, falls back to "/var/chef/backup".

Recipes
=======

This section describes the recipes in the cookbook and how to use them in your environment.

config
------

Sets up the `/etc/chef/client.rb` config file from a template and reloads the configuration for the current chef-client run.

service
-------

Use this recipe on systems that should have a `chef-client` daemon running, such as when Knife bootstrap was used to install Chef on a new system.

This recipe sets up the `chef-client` service depending on the `init_style` attribute (see above). The following init styles are supported:

* init - uses the init script included in the chef gem, supported on debian and redhat family distributions.
* upstart - uses the upstart job included in the chef gem, supported on ubuntu.
* arch - uses the init script included in this cookbook for ArchLinux, supported on arch.
* runit - sets up the service under runit, supported on ubuntu, debian and gentoo.
* bluepill - sets up the service under bluepill. As bluepill is a pure ruby process monitor, this should work on any platform.
* daemontools -sets up the service under daemontools, supported on debian, ubuntu and arch
* bsd - prints a message about how to update BSD systems to enable the chef-client service, supported on Free/OpenBSD and OSX.

default
-------

Includes the `chef-client::service` recipe by default.

`delete_validation`
-------------------

Use this recipe to delete the validation certificate (default `/etc/chef/validation.pem`) when using a `chef-client` after the client has been validated and authorized to connect to the server.

Beware if using this on your Chef Server. First copy the validation.pem certificate file to another location, such as your knife configuration directory (`~/.chef`) or [Chef Repository](http://wiki.opscode.com/display/chef/Chef+Repository).

USAGE
=====

Create a `base` role that will represent the base configuration for any system that includes managing aspects of the chef-client. Add recipes to the run list of the role, customize the attributes, and apply the role to nodes. For example, the following role (Ruby DSL) will set the init style to `init`, delete the validation certificate (as the client would already be authenticated) and set up the chef-client as a service using the init style.

    name "base"
    description "Base role applied to all nodes"
    override_attributes(
      "chef_client" => {
        "init_style" => "init"
      }
    )
    run_list(
      "recipe[chef-client::delete_validation]",
      "recipe[chef-client::config]",
      "recipe[chef-client::service]"
    )

The `chef-client::config` recipe is only required with init style `init` (default setting for the attribute on debian/redhat family platforms, because the init script doesn't include the `pid_file` option which is set in the config.

The default Chef Server will be `http://localhost:4000` which is the `Chef::Config[:chef_server_url]` default value. To use the config recipe with the Opscode Platform, for example, add the following to the `override_attributes`

    override_attributes(
      "chef_client" => {
        "server_url" => "https://api.opscode.com/organizations/ORGNAME",
        "validation_client_name" => "ORGNAME-validator"
      }
    )

Where ORGNAME is your Opscode Platform organization name. Be sure to add these attributes to the role if modifying per the section below.

You can also set all of the `Chef::Config` http proxy related settings.  By default Chef will not use a proxy.

    override_attributes(
      "chef_client" => {
        "http_proxy" => "http://proxy.vmware.com:3128",
        "https_proxy" => "http://proxy.vmware.com:3128",
        "http_proxy_user" => "my_username",
        "http_proxy_pass" => "Awe_some_Pass_Word!",
        "no_proxy" => "*.vmware.com,10.*"
      }
    )

Alternate Init Styles
---------------------

The alternate init styles available are:

* runit
* bluepill
* daemontools

For usage, see below.

# Runit

To use runit, download the cookbook from the cookbook site.

    knife cookbook site vendor runit -d

Change the `init_style` to runit in the base role and add the runit recipe to the role's run list:

    name "base"
    description "Base role applied to all nodes"
    override_attributes(
      "chef_client" => {
        "init_style" => "runit"
      }
    )
    run_list(
      "recipe[chef-client::delete_validation]",
      "recipe[runit]",
      "recipe[chef-client]"
    )

The `chef-client` recipe will create the chef-client service configured with runit. The runit run script will be located in `/etc/sv/chef-client/run`. The output log will be in the runit service directory, `/etc/sv/chef-client/log/main/current`.

# Bluepill

To use bluepill, download the cookbook from the cookbook site.

    knife cookbook site vendor bluepill -d

Change the `init_style` to runit in the base role and add the bluepill recipe to the role's run list:

    name "base"
    description "Base role applied to all nodes"
    override_attributes(
      "chef_client" => {
        "init_style" => "bluepill"
      }
    )
    run_list(
      "recipe[chef-client::delete_validation]",
      "recipe[bluepill]",
      "recipe[chef-client]"
    )

The `chef-client` recipe will create the chef-client service configured with bluepill. The bluepill "pill" will be located in `/etc/bluepill/chef-client.pill`. The output log will be to client.log file in the `node["chef_client"]["log_dir"]` location, `/var/log/chef/client` by default.

# Daemontools

To use daemontools, download the cookbook from the cookbook site.

    knife cookbook site vendor daemontools -d

Change the `init_style` to runit in the base role and add the daemontools recipe to the role's run list:

    name "base"
    description "Base role applied to all nodes"
    override_attributes(
      "chef_client" => {
        "init_style" => "daemontools"
      }
    )
    run_list(
      "recipe[chef-client::delete_validation]",
      "recipe[daemontools]",
      "recipe[chef-client]"
    )

The `chef-client` recipe will create the chef-cilent service configured under daemontools. It uses the same sv run scripts as the runit recipe. The run script will be located in `/etc/sv/chef-client/run`. The output log will be in the daemontools service directory, `/etc/sv/chef-client/log/main/current`.

Templates
=========

chef-client.pill.erb
--------------------

Bluepill configuration for the chef-client service.

client.rb.erb
-------------

Configuration for the client, lands in directory specified by `node["chef_client"]["conf_dir"]` (`/etc/chef/client.rb` by default).

`sv-chef-client-*run.erb`
-------------------------

Runit and Daemontools run script for chef-client service and logs.

Logs will be located in the `node["chef_client"]["log_dir"]`.

Changes/Roadmap
===============

## Future

* windows platform support

## 1.0.2:

* [CHEF-2491] init scripts should implement reload

## 1.0.0:

* [COOK-204] chef::client pid template doesn't match package expectations
* [COOK-491] service config/defaults should not be pulled from Chef gem
* [COOK-525] Tell bluepill to daemonize chef-client command
* [COOK-554] Typo in backup_path
* [COOK-609] chef-client cookbook fails if init_type is set to upstart and chef is installed from deb
* [COOK-635] Allow configuration of path to chef-client binary in init script

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)
Copyright:: 2010-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
