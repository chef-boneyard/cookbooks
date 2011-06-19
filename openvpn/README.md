DESCRIPTION
====

Installs OpenVPN and sets up a fairly basic configuration. Since OpenVPN is very complex, we provide a baseline, but your site will need probably need to customize.

REQUIREMENTS
====

OpenSSL bindings for Ruby

OpenSSL 0.9.7 or later

Tested on Ubuntu, but should work anywhere that has a package for OpenVPN.

Not Supported
----

This cookbook is designed to set up a basic installation of OpenVPN that will work for many common use cases. The following configurations are not supported by default with this cookbook:

* setting up routers and other network devices
* ethernet-bridging (tap interfaces)
* dual-factor authentication
* many other advanced OpenVPN configurations

For further modification of the cookbook see __USAGE__ below.

For more information about OpenVPN, see the [official site](http://openvpn.net/).

ATTRIBUTES
====

These attributes are set by the cookbook by default.

* `node["openvpn"]["local"]` - IP to listen on, defaults to node[:ipaddress]
* `node["openvpn"]["proto"]` - Valid values are 'udp' or 'tcp', defaults to 'udp'.
* `node["openvpn"]["type"]` - Valid values are 'server' or 'server-bridge'. Default is 'server' and it will create a routed IP tunnel, and use the 'tun' device. 'server-bridge' will create an ethernet bridge and requires a tap0 device bridged with the ethernet interface, and is beyond the scope of this cookbook.
* `node["openvpn"]["subnet"]` - Used for server mode to configure a VPN subnet to draw client addresses. Default is 10.8.0.0, which is what the sample OpenVPN config package uses.
* `node["openvpn"]["netmask"]` - Netmask for the subnet, default is 255.255.0.0.
* `node["openvpn"]["gateway"]` - FQDN for the VPN gateway server. Default is `node["fqdn"]`.
* `node["openvpn"]["log"]` - Server log file. Default /var/log/openvpn.log
* `node["openvpn"]["key_dir"]` - Location to store keys, certificates and related files. Default `/etc/openvpn/keys`.
* `node["openvpn"]["signing_ca_cert"]` - CA certificate for signing, default `/etc/openvpn/keys/ca.crt`
* `node["openvpn"]["signing_ca_key"]` - CA key for signing, default `/etc/openvpn/keys/ca.key`
* `node["openvpn"]["push"]` - Array of routes to add as `push` statements in the server.conf. Default is empty.

The following attributes are used to populate the `easy-rsa` vars file. Defaults are the same as the vars file that ships with OpenVPN.

* `node["openvpn"]["key"]["ca_expire"]` - In how many days should the root CA key expire - `CA_EXPIRE`.
* `node["openvpn"]["key"]["expire"]` - In how many days should certificates expire - `KEY_EXPIRE`.
* `node["openvpn"]["key"]["size"]` - Default key size, set to 2048 if paranoid but will slow down TLS negotiation performance - `KEY_SIZE`.

The following are for the default values for fields place in the certificate from the vars file. Do not leave these blank.

* `node["openvpn"]["key"]["country"]` - `KEY_COUNTRY`
* `node["openvpn"]["key"]["province"]` - `KEY_PROVINCE`
* `node["openvpn"]["key"]["city"]` - `KEY_CITY`
* `node["openvpn"]["key"]["org"]` - `KEY_ORG`
* `node["openvpn"]["key"]["email"]` - `KEY_EMAIL`

RECIPES
====

default
----

Sets up an OpenVPN server.

users
----

Utilizes a data bag called `users` to generate OpenVPN keys for each user.

USAGE
====


Create a role for the OpenVPN server. See above for attributes that can be entered here.

    % cat roles/openvpn.rb
    name "openvpn"
    description "The server that runs OpenVPN"
    run_list("recipe[openvpn]")
    override_attributes(
      "openvpn" => {
        "gateway" => "vpn.example.com",
        "subnet" => "10.8.0.0",
        "netmask" => "255.255.0.0",
        "key" => {
          "country" => "US",
          "province" => "CA",
          "city" => "SanFrancisco",
          "org" => "Fort-Funston",
          "email" => "me@example.com"
        }
      }
    )

To push routes to clients, add `node['openvpn']['push']` as an array attribute, e.g. if the internal network is 192.168.100.0/24:

    override_attributes(
      "openvpn" => {
        "push" => [
          "push 'route 192.168.100.0 255.255.255.0'"
        ]
      }
    )

To automatically create new certificates and configurations for users, create data bags for each user. The only content required is the `id`, but this can be used in conjunction with other cookbooks by Opscode such as `users` or `samba`. See __SSL Certificates__ below for more about generating client certificate sets.

    % cat data_bags/users/jtimberman.json
    {
      "id": "jtimberman"
    }

This cookbook also provides an 'up' script that runs when OpenVPN is started. This script is for setting up firewall rules and kernel networking parameters as needed for your environment. Modify to suit your needs, upload the cookbook and re-run chef on the openvpn server. For example, you'll probably want to enable IP forwarding (sample Linux setting is commented out).

Customizing Server Configuration
----

To further customize the server configuration, there are two templates that can be modified in this cookbook.

* templates/default/server.conf.erb
* templates/default/server.up.sh.erb

The first is the OpenVPN server configuration file. Modify to suit your needs for more advanced features of [OpenVPN](http://openvpn.net). The second is an `up` script run when OpenVPN starts. This is where you can add firewall rules, enable IP forwarding and other OS network settings required for OpenVPN. Attributes in the cookbook are provided as defaults, you can add more via the openvpn role if you need them.

SSL Certificates
----

Some of the easy-rsa tools are copied to /etc/openvpn/easy-rsa to provide the minimum to generate the certificates using the default and users recipes. We provide a Rakefile to make it easier to generate client certificate sets if you're not using the data bags above. To generate new client certificates you will need `rake` installed (either as a gem or a package), then run:

    cd /etc/openvpn/easy-rsa
    source ./vars
    rake client name="CLIENT_NAME" gateway="vpn.example.com"

Replace `CLIENT_NAME` and `vpn.example.com` with your desired values. The rake task will generate a tar.gz file with the configuration and certificates for the client.

LICENSE and AUTHOR
====

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009-2010, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
