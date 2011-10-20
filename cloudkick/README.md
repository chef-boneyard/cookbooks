Description
===========

Installs and configures the Cloudkick Agent, and integrates it with Chef.

Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Cookbooks
---------

* apt (leverages apt_repository LWRP)
* yum (leverages yum_repository LWRP)

The `apt_repository` and `yum_repository` LWRPs are used from these cookbooks to create the proper repository entries so the cloudkick agent can be downloaded and installed.

Usage
=====

In order for the agent to function, you'll need to have defined your Cloudkick API key and secret.  We recommend you do this in a Role, which should also take care of applying the cloudkick::default recipe.

Assuming you name the role 'cloudkick', here is the required json:

  {
    "name": "cloudkick",
    "chef_type": "role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "description": "Configures Cloudkick",
    "run_list": [
      "recipe[cloudkick]"
    ],
    "override_attributes": {
      "cloudkick": {
        "oauth_key": "YOUR KEY HERE"
        "oauth_secret": "YOUR SECRET HERE"
      }
    }
  }

If you want Cloudkick installed everywhere, we recommend you just add the cloudkick attributes to a base role.

All of the data about the node from Cloudkick is available in node[:cloudkick] - for example: 

  "cloudkick": {
    "oauth_key": "YOUR KEY HERE",
    "oauth_secret": "YOUR SECRET HERE",
    "data": {
      "name": "slice204393",
      "status": "running",
      "ipaddress": "173.203.83.199",
      "provider_id": "padc2665",
      "tags": [
        "agent",
        "cloudkick"
      ],
      "agent_state": "connected",
      "id": "n87cfc79c5",
      "provider_name": "Rackspace",
      "color": "#fffffff"
    }
  }

Of particular interest is the inclusion of the Cloudkick tags.  This will allow you to search Chef via tags placed on nodes within Cloudkick:

  $ knife search node 'cloudkick_data_tags:agent' -a fqdn
  {
    "rows": [
      {
        "fqdn": "slice204393",
        "id": "slice204393"
      }
    ],
    "start": 0,
    "total": 1
  }
  
We automatically add a tag for each Role applied to your node.  For example, if your node had a run list of:

  "run_list": [ "role[webserver]", "role[database_master]" ]

The node will automatically have the 'webserver' and 'database_master' tags within Cloudkick.

License and Author
==================

Author:: Adam Jacob (<adam@opscode.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)
Copyright:: 2010-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
