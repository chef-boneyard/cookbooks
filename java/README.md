Description
===========

Installs a Java. Uses OpenJDK by default but supports installation of the Sun's Java (Debian and Ubuntu platforms only).

---
Requirements
============

Platform
--------

* Debian, Ubuntu (OpenJDK, Sun)
* CentOS, Red Hat, Fedora (OpenJDK)

Cookbooks
---------

* apt

---
Attributes
==========

* `node["java"]["install_flavor"]` - Flavor of JVM you would like installed (`sun` or `openjdk`), default `openjdk`.

---
Recipes
=======

default
-------

Include the default recipe in a run list, to get `java`.  By default the `openjdk` flavor of Java is installed, but this can be changed by using the `install_flavor` attribute.

openjdk
-------

This recipe installs the `openjdk` flavor of Java.

sun
---

This recipe installs the `sun` flavor of Java.  The Sun flavor of Java is only supported on Debian and Ubuntu systems, the recipe will preseed the package and update java alternatives.

---
Usage
=====

Simply include the `php` recipe where ever you would like php installed.  To install from source override the `node['java']['install_flavor']` attribute with in a role:

    name "java"
    description "Install Sun Java."
    override_attributes(
      "java" => {
        "install_flavor" => "source"
      }
    )
    run_list(
      "recipe[java]"
    )

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
