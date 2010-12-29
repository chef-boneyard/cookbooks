Description
====

Installs OSSEC from source in a server-agent installation. See:

http://www.ossec.net/main/manual/manual-installation/

Requirements
====

Tested on Ubuntu and ArchLinux, but should work on any Unix/Linux platform supported by OSSEC. Installation by default is done from source, so the build-essential cookbook needs to be used (see below).

This cookbook doesn't configure Windows systems yet. For information on installing OSSEC on Windows, see the [free chapter](http://www.ossec.net/ossec-docs/OSSEC-book-ch2.pdf)

Cookbooks
----

build-essential is required for the default installation because it compiles from source. The cookbook may require modification to support other platforms' build tools - modify it accordingly before using.

Attributes
====

Default values are based on the defaults from OSSEC's own install.sh installation script.

* `node['ossec']['server_role']` - When using server/agent setup, this role is used to search for the OSSEC server, default `ossec_server`.
* `node['ossec']['checksum']` - SHA256 checksum of the source. Verified with SHA1 sum from OSSEC site.
* `node['ossec']['version']` - Version of OSSEC to download/install. Used in URL.
* `node['ossec']['url']` - URL to download the source.
* `node['ossec']['logs']` - Array of log files to analyze. Default is an empty array. These are in addition to the default logs in the ossec.conf.erb template.
* `node['ossec']['syscheck_freq']` - Frequency that syscheck is executed, default 22 hours (79200 seconds)
* `node['ossec']['server']['maxagents']` - Maximum number of agents, default setting is 256, but will be set to 1024 in the ossec::server recipe if used. Add as an override attribute in the `ossec_server` role if more nodes are required.

The `user` attributes are used to populate the config file (ossec.conf) and preload values for the installation script.

* `node['ossec']['user']['language']` - Language to use for installation, default en.
* `node['ossec']['user']['install_type']` - What kind of installation to perform, default is local. Using the client or server recipe will set this to `agent` or `server`, respectively.
* `node['ossec']['user']['dir']` - Installation directory for OSSEC, default `/var/ossec`.
* `node['ossec']['user']['delete_dir']` - Whether to delete the existing OSSEC installation directory, default true.
* `node['ossec']['user']['active_response']` - Whether to enable active response feature of OSSEC, default true. It is safe and recommended to leave this enabled.
* `node['ossec']['user']['syscheck']` - Whether to enable the integrity checking process, syscheck. Default true. It is safe and recommended to leave this enabled.
* `node['ossec']['user']['rootcheck']` - Whether to enable the rootkit checking process, rootcheck. Default true. It is safe and recommended to leave this enabled.
* `node['ossec']['user']['update']` - Whether an update installation should be done, default false.
* `node['ossec']['user']['update_rules']` - Whether to update rules files, default true.
* `node['ossec']['user']['binary_install']` - If true, use the binaries in the bin directory rather than compiling. Default false. The cookbook doesn't yet support binary installations.
* `node['ossec']['user']['agent_server_ip']` - The IP of the OSSEC server. The client recipe will attempt to determine this value via search. Default is nil, only required for agent installations.
* `node['ossec']['user']['enable_email']` - Enable or disable email alerting. Default is true.
* `node['ossec']['user']['email']` - Destination email address for OSSEC alerts. Default is `ossec@example.com` and should be changed via a role attribute.
* `node['ossec']['user']['smtp']` - Sets the SMTP relay to send email out. Default is 127.0.0.1, which assumes that a local MTA is set up (e.g., postfix).
* `node['ossec']['user']['remote_syslog']` - Whether to enable the remote syslog server on the OSSEC server. Default false, not relevant for non-server.
* `node['ossec']['user']['firewall_response']` - Enable or disable the firewall response which sets up firewall rules for blocking. Default is true.
* `node['ossec']['user']['pf']` - Enable PF firewall on BSD, default is false.
* `node['ossec']['user']['pf_table']` - The PF table to use on BSD. Default is false, set this to the desired table if enabling `pf`.
* `node['ossec']['user']['white_list']` - Array of additional IP addresses to white list. Default is empty.

Recipes
====

default
----

The default recipe downloads and installs the OSSEC source and makes sure the configuration file is in place and the service is started. Use only this recipe if setting up local-only installation. The server and client recipes (below) will set their installation type and include this recipe.

agent
----

OSSEC uses the term `agent` instead of client. The agent recipe includes the `ossec::client` recipe.

client
----

Configures the system as an OSSEC agent to the OSSEC server. This recipe will search for the server based on `node['ossec']['server_role']`. It will also set the `install_type` and `agent_server_ip` attributes. The ossecd user will be created with the SSH key so the server can distribute the agent key.

server
----

Sets up a system to be an OSSEC server. This recipe will set the `node['ossec']['server']['maxagents']` value to 1024 if it is not set on the node (e.g., via a role). It will search for all nodes that have an `ossec` attribute and add them as an agent.

To manage additional agents on the server that don't run chef, or for agentless OSSEC configuration (for example, routers), add a new node for them and create the `node['ossec']['agentless']` attribute as true. For example if we have a router named gw01.example.com with the IP `192.168.100.1`:

    % knife node create gw01.example.com
    {
      "name": "gw01.example.com",
      "json_class": "Chef::Node",
      "automatic": {
      },
      "normal": {
        "hostname": "gw01",
        "fqdn": "gw01.example.com",
        "ipaddress": "192.168.100.1",
        "ossec": {
          "agentless": true
        }
      },
      "chef_type": "node",
      "default": {
      },
      "override": {
      },
      "run_list": [
      ]
    }

Enable agentless monitoring in OSSEC and register the hosts on the server. Automated configuration of agentless nodes is not yet supported by this cookbook. For more information on the commands and configuration directives required in `ossec.conf`, see the [OSSEC Documentation](http://www.ossec.net/doc/manual/agent/agentless-monitoring.html)

Usage
====

The cookbook can be used to install OSSEC in one of the three types:

* local - use the ossec::default recipe.
* server - use the ossec::server recipe.
* agent - use the ossec::client recipe

For local-only installations, add just `recipe[ossec]` to the node run list, or put it in a role (like a base role).

Server/Agent
----

This section describes how to use the cookbook for server/agent configurations.

The server will use SSH to distribute the OSSEC agent keys. Create a data bag `ossec`, with an item `ssh`. It should have the following structure:

    {
      "id": "ssh",
      "pubkey": "",
      "privkey": ""
    }

Generate an ssh keypair and get the privkey and pubkey values. The output of the two ruby commands should be used as the privkey and pubkey values respectively in the data bag.

    ssh-keygen -t rsa -f /tmp/id_rsa
    ruby -e 'puts IO.read("/tmp/id_rsa")'
    ruby -e 'puts IO.read("/tmp/id_rsa.pub")'

For the OSSEC server, create a role, `ossec_server`. Add attributes per above as needed to customize the installation.

    % cat roles/ossec_server.rb
    name "ossec_server"
    description "OSSEC Server"
    run_list("recipe[ossec::server]")
    override_attributes(
      "ossec" => {
        "user" => {
          "email" => "ossec@yourdomain.com",
          "smtp" => "smtp.yourdomain.com"
        }
      }
    )

For OSSEC agents, create a role, `ossec_client`.

    % cat roles/ossec_client.rb
    name "ossec_client"
    description "OSSEC Client Agents"
    run_list("recipe[ossec::client]")
    override_attributes(
      "ossec" => {
        "user" => {
          "email" => "ossec@yourdomain.com",
          "smtp" => "smtp.yourdomain.com"
        }
      }
    )

Customization
----

The main configuration file is maintained by Chef as a template, `ossec.conf.erb`. It should just work on most installations, but can be customized for the local environment. Notably, the rules, ignores and commands may be modified.

Further reading:

* [OSSEC Documentation](http://www.ossec.net/doc/index.html)
* [OSSEC Wiki](http://www.ossec.net/wiki/OSSEC)

License and Author
====

Copyright 2010, Opscode, Inc (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
