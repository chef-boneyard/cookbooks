Description
===========

Creates an apache vhost and serves a very basic kickstart file.

Changes
=======

## v0.4.0:

* Current public release.

Requirements
============

## Platform:

Red Hat Enterprise Linux, CentOS, or other platforms that support Kickstart :-).

## Cookbooks:

* apache2

Attributes
==========

* `kickstart[:rootpw]` - set the root password. Use an encrypted string[1].
* `kickstart[:virtual_host_name]` - set the ServerName for apache2 vhost.
* `kickstart[:mirror_url]` - set the full URL to the "CentOS" directory w/ the rpms to install.

[Ruby way to encrypt](http://www.opensourcery.co.za/2009/05/01/quick-nix-shadow-passwords-with-ruby/)

Usage
=====

You'll almost certainly want to edit ks.cfg.erb to suit your environment. As is, the provided template is used as a minimal fast install for creating virtual machines to run CentOS 5. Of particular note, the following should definitely be changed:

* url - mirrors.kernel.org is usually fast for me, but maybe not for you.
* network - change the hostname.
* rootpw - this is an attribute, so you can change it by modifying the server. Use the encrypted password!

Storage / disks should probably be customized, as well as firewall rules, SELinux policy, and the package list.

The %post section will install Chef via Matthew Kent's RPMs, per the Chef Wiki instructions.

To use the recipe on a system that will be the kickstart server,

    include_recipe "kickstart::server"

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
