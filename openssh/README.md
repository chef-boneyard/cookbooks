Description
===========

Installs openssh.

Requirements
============

## Platform:

* Debian/Ubuntu
* RHEL/CentOS/Scientific
* Fedora
* ArchLinux

Recipes
=======

default
-------

Selects the packages to install by package name and manages the sshd
service.

Usage
=====

Ensure that the openssh packages are installed and the service is
managed with `recipe[openssh]`.

Attributes List
===============

The attributes list is dynamically generated, and lines up with the default openssh configs.

This means anything located in [sshd_config](http://www.openbsd.org/cgi-bin/man.cgi?query=sshd_config&sektion=5) or [ssh_config](http://www.openbsd.org/cgi-bin/man.cgi?query=sshd_config&sektion=5) can be used in your node attributes.

* If the option can be entered more then once, use an _Array_, otherwise, use a _String_.
* Each attribute is stored as ruby case, and converted to camel case for the config file on the fly.
* The current default attributes match the stock `ssh_config` and `sshd_config` provided by openssh.
* The namespace for `sshd_config` is `node[:openssh][:server]`.
* Likewise, the namespace for `ssh_config` is `node[:openssh][:client]`.
* An attribute can be an `Array` or a `String`.
* If it is an `Array`, each item in the array will get it's own line in the config file.
* All the values in openssh are commented out in the `attributes/default.rb` file for a base starting point.

Examples and Common usage
=========================

These can be mixed and matched in roles and attributes.  Please note, it is possible to get sshd into a state that it will not run.  If this is the case, you will need to login via an alternate method and debug sshd like normal.

#### No Password logins.

This requires use of identity files to connect

```json
"openssh": {
    "server": {
        "password_authentication": "no"
    }
}
```

#### Enable X Forwarding

```json
"openssh": {
		"server": {
				"x11_forwarding": "yes"
		}
}
```

####  Bind to a specific set of address (this example actually binds to all.)

```json
"openssh": {
		"server": {
        "address_family": "any",
        "listen_address": [ "192.168.0.1", "::" ]
		}
}
```
License and Author
==================

Author:: Adam Jacob <adam@opscode.com>

Copyright:: 2008-2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
