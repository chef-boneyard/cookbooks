DESCRIPTION
===========

This cookbook installs sudo and configures the /etc/sudoers file.

REQUIREMENTS
============

Requires that the platform has a package named sudo and the sudoers file is /etc/sudoers.

ATTRIBUTES
==========

The default recipe uses the following two attributes, which are set to blank arrays:

    node['authorization']['sudo']['groups']
    node['authorization']['sudo']['users']

They are passed into the sudoers template which iterates over the values to add sudo permission to the specified users and groups.

If you prefer to use passwordless sudo just set the following attribute to true:

    node['authorization']['sudo']['passwordless']

The data_bag recipe uses the "sudoers" data bag.  You will find examples in the data_bags directory.  The data_bag recipe also uses two different attributes:

    node['sudo']['users'] must be set -- this attribute contains users to add to /etc/sudoers.
    node['sudo']['testing'] set this to true to test your changes innocuously by creating /etc/sudoers.test instead of /etc/sudoers.

Set the users attribute at the role or environment level.

USAGE
=====

To use the default recipe, set the attributes above on the node via a role or the node object itself. In a role.rb:

    "authorization" => {
      "sudo" => {
        "groups" => ["admin", "wheel", "sysadmin"],
        "users" => ["jerry", "greg"],
        "passwordless" => true
      }
    }

In JSON (role.json or on the node object):

    "authorization": {
      "sudo": {
        "groups": [
          "admin",
          "wheel",
          "sysadmin"
        ],
        "users": [
          "jerry",
          "greg"
        ],
        "passwordless": true
      }
    }

Note that the template for the sudoers file has the group "sysadmin" with ALL:ALL permission, though the group by default does not exist.

To use the data_bags recipe, create:

    - Users in the data_bags/sudoers/users.json file
    Each user is then assigned to a User_Alias.

    - User_Aliases in the data_bags/sudoers/user_aliases.json file
    Each User_Alias contains a Cmnd_Alias, and is assigned to a Runas_Alias.  Set the value of "nopasswd" to true or false.
    
    Note also that there are ADMINS and ADMINS_NOPASSWD User_Aliases already set up to allow system-wide sudo access (with or without a password).

    - Runas_Aliases in the data_bags/sudoers/runas_aliases.json file
    Each Runas_Alias points to a specific UNIX user.

    - Cmnd_Aliases in the data_bags/sudoers/command_aliases.json file
    Each Cmnd_Alias is an array of allowed commands. 

To update your sudoers data bag, run:

# knife data bag from file sudoers data_bags/sudoers/users.json
# knife data bag from file sudoers data_bags/sudoers/user_aliases.json
# knife data bag from file sudoers data_bags/sudoers/runas_aliases.json
# knife data bag from file sudoers data_bags/sudoers/command_aliases.json

TESTING
=======
It's a good idea to test your changes to /etc/sudoers first, then run visudo -c -f /etc/sudoers.test.  If that passes, then it's a
better idea to remain logged in as root on a canary system, set node[:sudo][:testing] to false, re-run chef-client, then try sudo
again.   Remember that backup files are in /var/chef/backup. 

Consider yourself warned :)

LICENSE AND AUTHOR
==================

Author:: Adam Jacob <adam@opscode.com>
Author:: Seth Chisamore <schisamo@opscode.com>

Copyright 2009-2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
