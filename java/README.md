Description
===========

Installs a Java. Uses OpenJDK by default but supports installation of the Sun's Java.

---
Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

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

This recipe installs the `sun` flavor of Java.  

On Debian and Ubuntu systems the recipe will add the correct apt repository (`non-free` on Debian or `partner` on Ubuntu), pre-seed the package and update java alternatives.

On Red Hat flavored Linux (RHEL, CentOS, Fedora), the installation of the Sun flavor of Java is slightly more complicated as the `rpm` package is not readily available in any public Yum repository.  The Sun JDK `rpm` package can be downloaded directly from Sun but comes wrapped as a compressed bin file.  After the file has been downloaded, decompressed and license accepted the `rpm` package (names something like `jdk-6u25-ea-linux-amd64.rpm`) can be retrieved by this recipe using the `remote_file` or `cookbook_file` resources.  The recipe will choose the correct resource based on the existence (or non-existence) of the `node['sun']['rpm_url']` attribute.  See below for an example role using this attribute in the proper way.  If you would like to deliver the `rpm` package file as part of this cookbook place the `rpm` package file in the `files/default` directory and the cookbook will retrieve the file during installation.

---
Usage
=====

Simply include the `java` recipe where ever you would like Java installed.  

To install Sun flavored Java on Debian or Ubuntu override the `node['java']['install_flavor']` attribute with in role:

    name "java"
    description "Install Sun Java on Ubuntu"
    override_attributes(
      "java" => {
        "install_flavor" => "sun"
      }
    )
    run_list(
      "recipe[java]"
    )

On RedHat flavored Linux be sure to set the `rpm_url` and `rpm_checksum` attributes if you placed the `rpm` file on a remote server:

    name "java"
    description "Install Sun Java on CentOS"
    override_attributes(
      "java" => {
        "install_flavor" => "sun",
        "version" => "6u25",
        "rpm_url" => "https://mycompany.s3.amazonaws.com/sun_jdk",
        "rpm_checksum" => "c473e3026f991e617710bad98f926435959303fe084a5a31140ad5ad75d7bf13"
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
