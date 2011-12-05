Description
===========

Install and configure maven2 and maven3 from the binaries provided by the maven project

Requirements
============

Platform: 

* Debian, Ubuntu, CentOS, Red Hat, Fedora

The following Opscode cookbooks are dependencies:

* java

Attributes
==========

* default['maven']['version']  defaults to 2
* default['maven']['m2_home']  defaults to  '/usr/local/maven/'
* default['maven']['m2_download_url']  the download url for maven2
* default['maven']['m2_checksum']  the checksum, which you will have
 to recalculate if you change the download url
* default['maven']['m3_download_url'] download url for maven3
* default['maven']['m3_checksum'] the checksum, which you will have
 to recalculate if you change the download url


Usage
=====

Simply include the recipe where you want Apache Maven installed.

TODO
====


License and Author
==================

Author:: Bryan W. Berry (<bryan.berry@gmail.com>)

Copyright 2010, Bryan W. Berry

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

