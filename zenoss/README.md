Description
===========
Installs and configures a Zenoss server with the `zenoss::server` recipe. Devices can be added to the Zenoss server by using the `zenoss::client` recipe and utilizing Chef roles to map to Zenoss Device Classes, Locations and Groups. LWRPs are available for installing ZenPacks, zenpatches, loading devices and users and running zendmd commands.

CHANGELOG.md covers history and planned features

Requirements
============
Written with Chef 0.10 and uses recent search capabilities of roles.

The example roles in the `zenoss/roles` directory should be loaded for use, refer to the Roles subsection.

Testing
-------
Tested on Ubuntu 10.04 and CentOS 5.7 and tested with Chef 0.10.

Attributes
==========
Attributes under the `zenoss` namespace.

* `['zenoss']['device']['device_class']` - Device Class for the device, "/Discovered" is the default and may be overwritten at the Role or Node.
* `['zenoss']['device']['location']` - Location for the device, may be set at the Role or Node.
* `['zenoss']['device']['modeler_plugins']` - Modeler Plugins used by the device, may be set at the Role or Node.
* `['zenoss']['device']['properties']` - Configuration Properties used by the device, may be set at the Role or Node.
* `['zenoss']['device']['templates']` - Monitoring Templates used by the device, may be set at the Role or Node.
* `['zenoss']['server']['admin_password']` - Password for the `admin` account, default is `chefzenoss`
* `['zenoss']['server']['installed_zenpacks']` - Hash of ZenPacks and their versions, defaults are `"ZenPacks.zenoss.LinuxMonitor" => "1.1.5", "ZenPacks.community.MySQLSSH" => "0.4"`
* `['zenoss']['server']['zenhome']` - Directory of the Zenoss server installation, default is `/usr/local/zenoss/zenoss` for Debian/Ubuntu and `/opt/zenoss` for CentOS/RHEL/Scientific Linux.
* `['zenoss']['server']['zenoss_pubkey']` - Public key for the `zenoss` user used for monitoring. Set on the server automatically if it does not exist.
* `['zenoss']['server']['zenpatches']` - Hash of patches and the tickets providing the patches, defaults are `"23716" => "http://dev.zenoss.com/trac/ticket/7485", "23833" => "http://dev.zenoss.com/trac/ticket/6959"`

Resources/Providers
===================
zenbatchload
------------
This LWRP builds a list of devices, their Device Classes, Systems, Groups, Locations and their properties and populates the `zenoss::server` with them.

zendmd
------
This LWRP takes a command to be executed by the `zendmd` command on the Zenoss server. Examples include setting passwords and other changes to the Zope object database.

zenpack
-------
Installs ZenPacks on the `zenoss::server` for use for extending the base functionality.

zenpatch
--------
Installs patches on the `zenoss::server` based on the number referenced in the ticket.

Recipes
=======
Default
-------
The default recipe passes through to `zenoss::client`.

Client
------
The client includes the `openssh` recipe and adds the device to the Zenoss server for monitoring.

Server
------
The server includes the `openssh` and `apt` recipes. The server recipe installs Zenoss from either the .deb stack installer or the .rpm, handling and configuring all the dependencies.

The recipe does the following:

1. Installs Zenoss per the Zenoss Installation Guide.
2. Applies any patches that you have specified with the `['zenoss']['server']['zenpatches']` attribute.
3. Starts server (skipping the setup wizard).
4. Sets the `admin` password.
5. Searches for members of the `sysadmins` group by searching through `users` data bag and adds them to the server.
6. Creates a `zenoss` user for running Zenoss and monitoring clients via SSH.
7. Installs ZenPacks required for monitoring.
8. Adds itself to be monitored.
9. Creates Device Classes, Groups and Locations based on Chef roles containing custom settings.
10. Adds Systems to the server based on which recipes are used within Chef.
11. Finds all nodes implementing `zenoss::client` and adds them for monitoring and places them in the proper Device Classes, Groups, Systems and Locations and any node-specific settings as well via `zenbatchload`.

Data Bags
=========
Create a `users` data bag that will contain the users that will be able to log into the Zenoss server (members of the 'sysadmin' group). The admin user is automatically provided. Zenoss-specific information is stored in the `zenoss` hash. Passwords may be set or left out. Multiple roles may be set; the choices with Zenoss Core are Manager, ZenManager, ZenUser or empty. Users may belong to User Groups within Zenoss (listing them here will create them). Example user data bag item:

    {
    "id": "zenossadmin",
    "groups": "sysadmin",
    "zenoss": {
      "password": "abc",
      "roles": ["Manager", "ZenUser"],
      "user_groups": ["managers"],
      "pager": "zpager@example.com",
      "email": "zemail@example.com"
      }
    }

Two example data bags are provided and may be loaded like this:

    knife data bag create users
    knife data bag from file users cookbooks/zenoss/data_bags/Zenoss_User.json
    knife data bag from file users cookbooks/zenoss/data_bags/Zenoss_Readonly_User.json

Roles
=====
This cookbook provides a number of example roles for mapping attributes to Zenoss' Device Classes, Groups and Locations. There is also a role called "ZenossServer" that may be used to configure the Zenoss server for convenience. These roles may be loaded like this:

    knife role from file cookbooks/zenoss/roles/Class_Server-SSH-Linux.rb

Device Class Roles
------------------
* Roles intended to map to Device Classes set the attribute `[:zenoss][:device][:device_class]`. This is an override_attribute on the role.
* Roles may set default attributes for `[:zenoss][:device][:modeler_plugins]`, `[:zenoss][:device][:templates]` and `[:zenoss][:device][:properties]` to be applied to the Device Class.
* The `name` for the role is unused by Zenoss.
* Nodes may only belong to a single Device Class, nodes that belong to multiple Device Class roles will have non-determinant membership in a single Device Class.

Location Roles
--------------
* Roles intended to map to Locations set the attribute `[:zenoss][:device][:location]`. This is an override_attribute on the role.
* Location roles may set the have `[:zenoss][:device][:address]` attribute for the Google map address. If you are using a newline, make sure it is entered as `\\n` in the role. This is an override_attribute on the role.
* The `name` and the `description` for the role map to the name and description of the Location.
* Nodes may only belong to a single Location, nodes that belong to multiple Location roles will have non-determinant membership in a single Location.

Group Roles
-----------
* The roles in organization will populate the Groups on the Zenoss server.
* The Device Class and Location roles will not be added to Groups.

Usage
=====
For a Zenoss server add the following recipe to the run_list:

    recipe[zenoss::server]

This will allow device nodes to search for the server by this role. Devices are currently added by their external IP addresses, which is effective in hybrid clouds but you may want to modify this for environments in a single platform (ie. EC2-only). Check the `providers/zenbatchload.rb` for this setting. Running `chef-client --log_level debug` on the server node will show the calls for zendmd and zenbatchload commands.

To register a device for monitoring with Zenoss on a client node:

    include_recipe "zenoss::client"

Any Properties that need to be set are exposed as attributes on the node and the Roles used by this cookbook.

Zenoss has the concept of Devices, which belong to a single Device Class and Location. Chef nodes implementing the `zenoss::client` recipe become Zenoss Devices and the Device Class and Location roles may be used for placing in the proper organizers. Zenoss also has Groups and Systems which are essentially ways of tagging and organizing devices (and devices may belong to multiple Groups and Systems). Searches for nodes that belong to other roles will populate the Groups. Searches for nodes applying recipes are used to populate the Systems.

If you are monitoring devices running on Amazon's EC2 with Zenoss, you will need to allow ICMP ping from your Zenoss server.

Because of limitations in zenbatchload, changing settings after initial configuration may not persist. This will be revisited with the upcoming Zenoss 4.x release (COO-895).

License and Author
==================
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2010, Zenoss, Inc
Copyright:: 2010, 2011 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
