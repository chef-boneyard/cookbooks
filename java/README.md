Description
===========

Installs a Java. Uses OpenJDK by default but supports installation of the Sun's Java (Debian and Ubuntu platforms only).

Requirements
============

Platform: 

* Debian, Ubuntu (OpenJDK, Sun)
* CentOS, Red Hat, Fedora (OpenJDK)

The following Opscode cookbooks are dependencies:

* apt

Attributes
==========

* `node["java"]["install_flavor"]` - Type of JRE you would like installed ("sun" or "openjdk"), default "openjdk".

Usage
=====

Simply include the recipe where you want Java installed.

If you would like to use the Sun flavor of Java, create a role and set the `java[install_flavor]` attribute to `'sun'`.  

    % knife role show java
    {
      "name": "java",
      "chef_type": "role",
      "json_class": "Chef::Role",
      "default_attributes": {
        "java": {
          "install_flavor":"sun"
        }
      },
      "description": "",
      "run_list": [
        "recipe[java]"
      ],
      "override_attributes": {
      }
    }

The Sun flavor of Java is only supported on Debian and Ubuntu systems, the recipe will preseed the package and update java alternatives.

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2008-2010, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
