DESCRIPTION
===========

Automatically configures system DNS using Dyn's API.

REQUIREMENTS
============

Chef 0.8+.

A Dynect account.

The `dynect_rest` gem. The `dynect::default` recipe installs this gem from gemcutter.

Works on any platform Chef runs on that can install gems from Rubygems.org.

ATTRIBUTES
==========

The following attributes need to be set either in a role or on a node directly, they are not set at the cookbook level:

* dynect.customer - Customer ID
* dynect.username - Username
* dynect.password - Password
* dynect.zone - Zone
* dynect.domain - Domain

Example JSON:

    {
      "dynect": {
        "customer": "CUSTOMER",
        "username": "USERNAME",
        "password": "PASSWORD",
        "zone": "ZONE",
        "domain": "DOMAIN"
      }
    }

EC2 specific attributes:

* dynect.ec2.type - type of system, web, db, etc. Default is 'ec2'.
* dynect.ec2.env - logical application environment the system is in. Default is 'prod'.

RESOURCES
=========

rr
--

DNS Resource Record.

Actions:

Applies to the DNS record being managed.

* `:create`
* `:replace`
* `:update`
* `:delete`

Attribute Parameters:

* `record_type` - DNS record type (CNAME, A, etc)
* `rdata` - record data, see the Dyn API documentation.
* `ttl` - time to live in seconds
* `fqdn` - fully qualified domain name
* `username` - dyn username
* `password` - dyn password
* `customer` - dyn customer id
* `zone` - DNS zone

None of the parameters have default values.

Example:

    dynect_rr "webprod" do
      record_type "A"
      rdata({"address" => "10.1.1.10"})
      fqdn "webprod.#{node.dynect.domain}"
      customer node[:dynect][:customer]
      username node[:dynect][:username]
      password node[:dynect][:password]
      zone     node[:dynect][:zone]
    end

RECIPES
=======

This cookbook provides the following recipes.

default
-------

The default recipe installs Adam Jacob's `dynect_rest` gem during the Chef run's compile time to ensure it is available in the same run as utilizing the `dynect_rr` resource/provider.

ec2
---

**Only use this recipe on Amazon AWS EC2 hosts!**

The `dynect::ec2` recipe provides an example of working with the Dyn API with EC2 instances. It creates CNAME records based on the EC2 instance ID (`node.ec2.instance_id`), and a constructed hostname from the dynect.ec2 attributes.

The recipe also edits resolv.conf to search compute-1.internal and the dynect.domain and use dynect.domain as the default domain, and it will set the nodes hostname per the DNS settings.

a_record
--------

The `dynect::a_record` recipe will create an `A` record for the node using the detected hostname and IP address from `ohai`.

FURTHER READING
===============

Information on the Dynect API:

* [PDF](http://cdn.dyndns.com/pdf/Dynect-API.pdf)

Dynect REST Ruby Library:

* [Gem](http://rubygems.org/gems/dynect_rest)
* [Code](http://github.com/adamhjk/dynect_rest)

LICENSE AND AUTHOR
==================

- Author: Adam Jacob (<adam@opscode.com>)
- Copyright: 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
