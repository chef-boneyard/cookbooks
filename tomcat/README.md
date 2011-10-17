Description
===========

Installs and configures the Tomcat, Java servlet engine and webserver.

Requirements
============

Platform: 

* Debian, Ubuntu (OpenJDK, Sun)
* CentOS, Red Hat, Fedora (OpenJDK)

The following Opscode cookbooks are dependencies:

* java
* jpackage

Attributes
==========

* `node["tomcat"]["port"]` - The network port used by Tomcat's HTTP connector, default `8080`.
* `node["tomcat"]["ssl_port"]` - The network port used by Tomcat's SSL HTTP connector, default `8443`.
* `node["tomcat"]["ajp_port"]` - The network port used by Tomcat's AJP connector, default `8009`.
* `node["tomcat"]["java_options"]` - Extra options to pass to the JVM, default `-Xmx128M -Djava.awt.headless=true`.
* `node["tomcat"]["use_security_manager"]` - Run Tomcat under the Java Security Manager, default `false`.

Usage
=====

Simply include the recipe where you want Tomcat installed.

TODO
====

* SSL support
* create a LWRP for deploying WAR files (file based and )

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2010, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
