Description
===========

Installs and configures SNORT.

Requirements
============

Tested on Ubuntu. May work on Debian, and Red Hat family distributions. Won't work on other platforms.

Cookbooks
----

No other cookbooks are strictly required, however to use one of the database backends, the appropriate cookbook should be used. For example, Opscode cookbooks:

* mysql
* postgresql

Attributes
==========

* `node['snort']['home_net']` - Address range to use for preseeding `HOME_NET`. Default 192.168.0.0/16 on Ubuntu/Debian, all others any.
* `node['snort']['database']` - What database backend to use. Default none. MySQL and PostgreSQL are usable. The default recipe will install the SNORT package for the appropriate database backend. You'll need to make sure that the database server is set up in some way such that SNORT can connect to it. This cookbook does not yet support automatic configuration.

Usage
=====

Include `recipe[snort]` in a run list to have the system get SNORT installed. This performs a baseline installation and preseeds the package. You'll probably want to change the `node['snort']['home_net']` attribute to the appropriate network.

We recommend adding a `template` resource to the default recipe to manage the `/etc/snort/snort.conf` file as a template. The default file is good enough for now on Debian/Ubuntu.

On Ubuntu/Debian, the default rules package will be installed. You'll need to download and install additional rules. Automatically updating rules with oinkmaster is not yet supported.  See future plans.

Future Plans
============

The following features are planned for a future release of this cookbook. Contributions welcome, see [How to Contribute](http://wiki.opscode.com/display/chef/How+to+Contribute)

Perform additional configuration of `/etc/snort/snort.conf` via template.

Preseed database configuration for SNORT to connect to the database server. This will use Chef search results for the database master.

Support either RPM or Yum based installations on Red Hat family distributions.

Oinkmaster automatic rules updates.

Source-based installation.

Other platforms in general :).

References
==========

* [SNORT home page](http://www.snort.org)
* [snort -h doesn't do what you think](http://blog.joelesler.net/2010/03/snort-h-doesnt-do-what-you-think-it-does.html)

License and Author
==================

Author: Joshua Timberman (<joshua@opscode.com>)
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
