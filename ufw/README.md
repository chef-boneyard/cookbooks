Description
===========
Configures Uncomplicated Firewall (ufw) on Ubuntu. Including the `ufw` recipe in a run list means the firewall will be enabled and will deny everything except SSH and ICMP ping by default.

Rules may be added to the node by adding them to the `['firewall']['rules']` attributes in roles or on the node directly. The `firewall` cookbook has an LWRP that may be used to apply rules directly from other recipes as well. There is no need to explicitly remove rules, they are reevaluated on changes and reset. Rules are applied in the order of the run list, unless ordering is explictly added.

Requirements
============
Tested with Ubuntu 10.04 and 11.04.

Recipes
=======
default
-------
The `default` recipe looks for the list of firewall rules to apply from the `['firewall']['rules']` attribute added to roles and on the node itself. The list of rules is then applied to the node in the order specified.

disable
-------
The `disable` recipe is used if there is a need to disable the existing firewall, perhaps for testing. It disables the ufw firewall even if other ufw recipes attempt to enable it.

If you remove this recipe, the firewall does not get automatically re-enabled. You will need clear the value of the `['firewall']['state']` to force a recalculation of the firewall rules. This can be done with `knife node edit`.

databag
-------
The `databag` recipe looks in the `firewall` data bag for to apply firewall rules based on inspecting the runlist for roles and recipe names for keys that map to the data bag items and are applied in the the order specified.

The `databag` recipe calls the `default` recipe after the `['firewall']['rules']` attribute is set to appy the rules, so you may mix roles with databag items if you want (roles apply first, then data bag contents).

recipes
-------
The `recipes` recipe applies firewall rules based on inspecting the runlist for recipes that have node[<recipe>]['firewall']['rules'] attributes. These are appended to node['firewall']['rules'] and applied to the node. Cookbooks may define attributes for recipes like so:

# attributes/default.rb for test cookbook
    default['test']['firewall']['rules'] = [
      "test"=> {
        "port"=> "27901",
        "protocol"=> "udp"
      }
    ]
    default['test::awesome']['firewall']['rules'] = [
      "awesome"=> {
        "port"=> "99427",
        "protocol"=> "udp"
      },
      "awesome2"=> {
        "port"=> "99428"
      }
    ]

Note that the 'test::awesome' rules are only applied if that specific recipe is in the runlist. Recipe-applied firewall rules are applied after any rules defined in role attributes.

securitylevel
-------------
The `securitylevel` recipe is used if there are any node['firewall']['securitylevel'] settings that need to be enforced. It is a reference implementation with nothing configured.

Attributes
==========
Roles and the node may have the `['firewall']['rules']` attribute set. This attribute is a list of hashes, the key will be rule name, the value will be the hash of parameters. Application order is based on run list.

# Example Role
    name "fw_example"
    description "Firewall rules for Examples"
    override_attributes(
      "firewall" => {
        "rules" => [
          {"tftp" => {}},
          {"http" => {
              "port" => "80"
            }
          },
          {"block tomcat from 192.168.1.0/24" => {
              "port" => "8080",
              "source" => "192.168.1.0/24",
              "action" => "deny"
            }
          },
          {"Allow access to udp 1.2.3.4 port 5469 from 1.2.3.5 port 5469" => {
              "protocol" => "udp",
              "port" => "5469",
              "source" => "1.2.3.4",
              "destination" => "1.2.3.5",
              "dest_port" => "5469"
            }
          }
        ]
      }
      )

Data Bags
=========
The `firewall` data bag may be used with the `databag` recipe. It will contain items that map to role names (eg. the 'apache' role will map to the 'apache' item in the 'firewall' data bag). Either roles or recipes may be keys (role[webserver] is 'webserver', recipe[apache2] is 'apache2'). If you have recipe-specific firewall rules, you will need to replace the '::' with '__' (double underscores) (eg. recipe[apache2::mod_ssl] is 'apache2__mod_ssl' in the data bag item).

The items in the data bag will contain a 'rules' array of hashes to apply to the `['firewall']['rules']` attribute.

    % knife data bag create firewall
    % knife data bag from file firewall examples/data_bags/firewall/apache2.json

# Example 'firewall' data bag item

    {
        "id": "apache2",
        "rules": [
            {"http": {
                "port": "80"
            }},
            {"block http from 192.168.1.0/24": {
                "port": "80",
                "source": "192.168.1.0/24",
                "action": "deny"
            }}
        ]
    }

Resources/Providers
===================
The `firewall` cookbook provides the `firewall` and `firewall_rule` LWRPs, for which there is a ufw provider.

License and Author
==================
Author:: Matt Ray (<matt@opscode.com>)

Copyright:: 2011 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
