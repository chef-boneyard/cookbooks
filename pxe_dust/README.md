Description
===========
Installs and configures a tftpd server for serving Ubuntu installers over PXE and setting them to run a provided preseed.cfg. 

Requirements
============
Written and tested with Chef 0.9.14 and Ubuntu 10.10.

Attributes
==========
Attributes under the `pxe_dust` namespace.

* `["pxe_dust"]["arch"]` - Architecture of the netboot.tar.gz to use as the source of pxeboot images.
* `["pxe_dust"]["tftpboot"]` - Path of the tftpboot directory used for sharing images.
* `["pxe_dust"]["version"]` - Ubuntu version of the netboot.tar.gz to use as the source of pxeboot images.

Templates
=========
syslinux.cfg.erb
----------------
Sets the boot prompt to automatically run the installer.

txt.cfg.erb
-----------
Sets the URL to the preseed file.

preseed.cfg.erb
---------------
The preseed file is full of opinions, you will want to update this. If there is a node providing an apt-cacher proxy via the `[apt::cacher]` recipe, it is provided in the preseed.cfg.

Recipes
=======
Default
-------
The default recipe passes through to `pxe_dust::server`.

Server
------
The server includes the `apache2` recipe and installs the `tftpd-hpa` package.

The recipe does the following:

1. Downloads the proper netboot.tar.gz to boot from.
2. Untars it to the tftpboot directory.
3. Instructs the installer prompt to automatically install.
4. Passes the URL of the preseed.cfg to the installer.
5. Uses the preseed.cfg template to pass in any `apt-cacher` proxies.

Usage
=====
For a pxe_dust server add the following recipe to the run_list:

    recipe[pxe_dust::server]

This cookbook does not provide DHCP or bootp to listen for PXE boot requests, this URL will have to be provided by another cookbook or manually. The author had to do this manually on a DD-WRT router.

Side note, for DD-WRT bootp support [this forum post was followed](http://www.dd-wrt.com/phpBB2/viewtopic.php?t=4662). The key syntax was 

    dhcp-boot=pxelinux.0,,192.168.1.147
    
in the section `Additional DNSMasq Options` where the IP address is that of the tftpd server we're configuring here and pxelinux.0 is from the netboot tarball.

License and Author
==================
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2011 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
