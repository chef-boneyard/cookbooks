Description
===========

This cookbook provides libraries, resources and providers to configure and manage Amazon Web Services components and offerings with the EC2 API. Currently supported resources:

* EBS Volumes (`ebs_volume`)
* Elastic IPs (`elastic_ip`)

---
Requirements
============

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended. While this cookbook can be used in `chef-solo` mode, to gain the most flexibility, we recommend using `chef-client` with a Chef Server.

An Amazon Web Services account is required. The Access Key and Secret Access Key are used to authenticate with EC2.

---
AWS Credentials
===============

In order to manage AWS components, authentication credentials need to be available to the node. There are a number of ways to handle this, such as node attributes or roles. We recommend storing these in a databag (Chef 0.8+), and loading them in the recipe where the resources are needed.

DataBag recommendation:

    % knife data bag show aws main
    {
      "id": "main",
      "aws_access_key_id": "YOUR_ACCESS_KEY",
      "aws_secret_access_key": "YOUR_SECRET_ACCESS_KEY"
    }

This can be loaded in a recipe with:

    aws = data_bag_item("aws", "main")

And to access the values:

    aws['aws_access_key_id']
    aws['aws_secret_access_key']

We'll look at specific usage below.

---
Recipes
=======

default.rb
----------

The default recipe installs the `right_aws` RubyGem, which this cookbook requires in order to work with the EC2 API. Make sure that the aws recipe is in the node or role `run_list` before any resources from this cookbook are used.

    "run_list": [
      "recipe[aws]"
    ]

The `gem_package` is created as a Ruby Object and thus installed during the Compile Phase of the Chef run.

---
Libraries
=========

The cookbook has a library module, `Opscode::AWS::Ec2`, which can be included where necessary:

    include Opscode::Aws::Ec2

This is needed in any providers in the cookbook. Along with some helper methods used in the providers, it sets up a class variable, `ec2` that is used along with the access and secret access keys

---
Resources and Providers
=======================

This cookbook provides two resources and corresponding providers.

ebs_volume.rb
-------------

Manage Elastic Block Store (EBS) volumes with this resource.

Actions:

* `create` - create a new volume.
* `attach` - attach the specified volume.
* `detach` - detach the specified volume.
* `snapshot` - create a snapshot of the volume.
* `prune` - prune snapshots.

Attribute Parameters:

* `aws_secret_access_key`, `aws_access_key` - passed to `Opscode::AWS:Ec2` to authenticate, required.
* `size` - size of the volume in gigabytes.
* `snapshot_id` - snapshot to build EBS volume from.
* `availability_zone` - EC2 region, and is normally automatically detected.
* `device` - local block device to attach the volume to, e.g. `/dev/sdi` but no default value, required.
* `volume_id` - specify an ID to attach, cannot be used with action `:create` because AWS assigns new volume IDs
* `timeout` - connection timeout for EC2 API.
* `snapshots_to_keep` - used with action `:prune` for number of snapshots to maintain.

elastic_ip.rb
-------------

Actions:

* `associate` - associate the IP.
* `disassociate` - disassociate the IP.

Attribute Parameters:

* `aws_secret_access_key`, `aws_access_key` - passed to `Opscode::AWS:Ec2` to authenticate, required.
* `ip` - the IP address.
* `timeout` - connection timeout for EC2 API.


---
Usage
=====

For both the `ebs_volume` and `elastic_ip` resources, put the following at the top of the recipe where they are used.

    include_recipe "aws"
    aws = data_bag_item("aws", "main")

aws_ebs_volume
--------------

The resource only handles manipulating the EBS volume, additional resources need to be created in the recipe to manage the attached volume as a filesystem or logical volume.

    aws_ebs_volume "db_ebs_volume" do
      aws_access_key aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key_id']
      size 50
      device "/dev/sdi"
      action [ :create, :attach ]
    end

This will create a 50G volume, attach it to the instance as `/dev/sdi`.

    aws_ebs_volume "db_ebs_volume_from_snapshot" do
      aws_access_key aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key_id']
      size 50
      device "/dev/sdi"
      snapshot_id "snap-ABCDEFGH"
      action [ :create, :attach ]
    end

This will create a new 50G volume from the snapshot ID provided and attach it as `/dev/sdi`.

aws_elastic_ip
--------------

The `elastic_ip` resource provider does not support allocating new IPs. This must be done before running a recipe that uses the resource. After allocating a new Elastic IP, we recommend storing it in a databag and loading the item in the recipe.

Databag structure:

    % knife data bag show aws eip_load_balancer_production
    {
      "id": "eip_load_balancer_production",
      "public_ip": "YOUR_ALLOCATED_IP"
    }

Then to set up the Elastic IP on a system:

    ip_info = data_bag_item("aws", "eip_load_balancer_production")

    aws_elastic_ip "eip_load_balancer_production" do
      aws_access_key aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key_id']
      lb ip_info['public_ip']
      action :associate
    end

This will use the loaded `aws` and `ip_info` databags to pass the required values into the resource to configure. Note that when associating an Elastic IP to an instance, connectivity to the instance will be lost because the public IP address is changed. You will need to reconnect to the instance with the new IP.

You can also store this in a role as an attribute or assign to the node directly, if preferred.

---
License and Author
==================

Author:: Chris Walters (<cw@opscode.com>)
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
