Database Cookbook
=================

Configures mysql database masters and slaves and uses EBS for storage, integrating together with the application cookbook utilizing data bags for application related information.

This cookbook is written primarily to use MySQL and the Opscode mysql cookbook. Other RDBMS may be supported at a later date.

This cookbook does not automatically restore database dumps, but does install tools to help with that.

---
Recipes
=======

ebs_volume
----------

Loads the aws information from the data bag. Searches the applications data bag for the database master or slave role and checks that role is applied to the node. Loads the EBS information and the master information from data bags. Uses the aws cookbook LWRP, `aws_ebs_volume` to manage the volume.

On a master node:
* if we have an ebs volume already as stored in a data bag, attach it.
* if we don't have the ebs information then create a new one and attach it.
* store the volume information in a data bag via a ruby block.

On a slave node:
* use the master volume information to generate a snapshot.
* create the new volume from the snapshot and attach it.

Also on a master node, generate some configuration for running a snapshot via `chef-solo` from cron.

On a new filesystem volume, create as XFS, then mount it in /mnt, and also bind-mount it to the mysql data directory (default /var/lib/mysql).

master
------

Loads the AWS information from a data bag. Create the databases for the application per the role checking magic, if they don't exist. Install s3cmd and create a config file so we can do manual database restores from dumpfiles if necessary. Finally store the replication status in a data bag.

slave
-----

Retrieve the master status from a data bag, then start replication using a ruby block.

snapshot
--------

Run via chef-solo. Retrieves the db snapshot configuration from the specified JSON file. Uses the `mysql_database` LWRP to lock and unlock tables, and does a filesystem freeze and EBS snapshot.

---
Deprecated Recipes
==================

The following recipes are no longer used as they have been deprecated in functionality both the above.

ebs_backup
----------

Older style of doing mysql snapshot and replication using Adam Jacob's [ec2_mysql][0] script and library

[0]: http://github.com/adamhjk/ec2_mysql

---
Data Bags
=========

This recipe uses the apps data bag item for the specified application; see the `application` cookbook's README.txt. It also creates data bag items in a bag named 'aws' for storing volume information. In order to interact with EC2, it expects aws to have a main item:

    {
      "id": "main",
      "ec2_private_key": "private key as a string",
      "ec2_cert": "certificate as a string",
      "aws_account_id": "",
      "aws_secret_access_key": "",
      "aws_access_key_id": ""
    }

Note: with the Open Source Chef Server, the server using the database recipes must be an admin client or it will not be able to create data bag items. You can modify whether the client is admin by editing it with knife.

    knife client edit <client_name>
    {
      ...
      "admin": true
      ...
    }

This is not required if the Chef Server is the Opscode Platform.

---
Usage
=====

Aside from the application data bag (see the README.txt in the application cookbook), create a role for the database master in the chef-repo:

    % vi roles/my_app_database_maser.rb
    name "my_app_database_master"
    description "Set up a MySQL DB master for the my_app application"
    run_list(
      "recipe[my_app_database]",
      "recipe[database::ebs_volume]",
      "recipe[database::master]"
    )
    % knife role from file roles/my_app_database_master.rb

The cookbook `my_app_database` is recommended to set up any application specific database resources such as configuration templates, trending monitors, etc. It is not required, but you would need to create it separately in `site-cookbooks`.

License and Author
==================

Author:: Adam Jacob (<adam@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: AJ Christensen (<aj@opscode.com>)

Copyright 2009-2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
