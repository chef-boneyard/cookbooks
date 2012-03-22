Description
===========

Installs and configures PHP 5.3 and the PEAR package management system.  Also includes LWRPs for managing PEAR (and PECL) packages along with PECL channels.

---
Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Cookbooks
---------

* build-essential
* xml
* mysql

These cookbooks are only used when building PHP from source.

---
Attributes
==========

* `node["php"]["install_method"]` = method to install php with, default `package`.

The file also contains the following attribute types:

* platform specific locations and settings.
* source installation settings

---
Resource/Provider
=================

This cookbook includes LWRPs for managing:

* PEAR channels
* PEAR/PECL packages

`php_pear_channel`
------------------

[PEAR Channels](http://pear.php.net/manual/en/guide.users.commandline.channels.php) are alternative sources for PEAR packages.  This LWRP provides and easy way to manage these channels.

# Actions

- :discover: Initialize a channel from its server.
- :add: Add a channel to the channel list, usually only used to add private channels.  Public channels are usually added using the `:discover` action
- :update: Update an existing channel
- :remove: Remove a channel from the List

# Attribute Parameters

- channel_name: name attribute. The name of the channel to discover
- channel_xml: the channel.xml file of the channel you are adding

# Example
    
    # discover the horde channel
    php_pear_channel "pear.horde.org" do
      action :discover
    end
    
    # download xml then add the symfony channel
    remote_file "#{Chef::Config[:file_cache_path]}/symfony-channel.xml" do
      source "http://pear.symfony-project.com/channel.xml"
      mode 0644
    end
    php_pear_channel "symfony" do
      channel_xml "#{Chef::Config[:file_cache_path]}/symfony-channel.xml"
      action :add
    end
    
    # update the main pear channel
    php_pear_channel 'pear.php.net' do
      action :update
    end
    
    # update the main pecl channel
    php_pear_channel 'pecl.php.net' do
      action :update
    end
    

`php_pear`
----------

[PEAR](http://pear.php.net/) is a framework and distribution system for reusable PHP components. [PECL](http://pecl.php.net/) is a repository for PHP Extensions. PECL contains C extensions for compiling into PHP. As C programs, PECL extensions run more efficiently than PEAR packages. PEARs and PECLs use the same packaging and distribution system.  As such this LWRP is clever enough to abstract away the small differences and can be used for managing either.  This LWRP also creates the proper module .ini file for each PECL extension at the correct location for each supported platform.

# Actions

- :install: Install a pear package - if version is provided, install that specific version
- :upgrade: Upgrade a pear package - if version is provided, upgrade to that specific version
- :remove: Remove a pear package
- :purge: Purge a pear package (this usually entails removing configuration files as well as the package itself).  With pear packages this behaves the same as `:remove`

# Attribute Parameters

- package_name: name attribute. The name of the pear package to install
- version: the version of the pear package to install/upgrade.  If no version is given latest is assumed.
- preferred_state: PEAR by default installs stable packages only, this allows you to install pear packages in a devel, alpha or beta state
- directives: extra extension directives (settings) for a pecl. on most platforms these usually get rendered into the extension's .ini file
- zend_extensions: extension filenames which should be loaded with zend_extension.
- options: Add additional options to the underlying pear package command


# Example

    # upgrade a pear
    php_pear "XML_RPC" do
      action :upgrade
    end
    
    
    # install a specific version
    php_pear "XML_RPC" do
      version "1.5.4"
      action :install
    end
    
    
    # install the mongodb pecl
    php_pear "mongo" do
      action :install
    end

    # install the xdebug pecl
    php_pear "xdebug" do
      # Specify that xdebug.so must be loaded as a zend extension
      zend_extensions ['xdebug.so']
      action :install
    end
    
    
    # install apc pecl with directives
    php_pear "apc" do
      action :install
      directives(:shm_size => 128, :enable_cli => 1)
    end
    
    
    # install the beta version of Horde_Url 
    # from the horde channel
    hc = php_pear_channel "pear.horde.org" do
      action :discover
    end
    php_pear "Horde_Url" do
      preferred_state "beta"
      channel hc.channel_name
      action :install
    end
    
    
    # install the YAML pear from the symfony project
    sc = php_pear_channel "pear.symfony-project.com" do
      action :discover
    end
    php_pear "YAML" do
      channel sc.channel_name
      action :install
    end
    
---
Recipes
=======

default
-------

Include the default recipe in a run list, to get `php`.  By default `php` is installed from packages but this can be changed by using the `install_method` attribute.

package
-------

This recipe installs PHP from packages.

source
------

This recipe installs PHP from source.

---
Deprecated Recipes
==================

The following recipes are deprecated and will be removed from a future version of this cookbook.

* `module_apc`
* `module_curl`
* `module_fileinfo`
* `module_fpdf`
* `module_gd`
* `module_ldap`
* `module_memcache`
* `module_mysql`
* `module_pgsql`
* `module_sqlite3`

The installation of the php modules in these recipes can now be accomplished by installing from a native package or via the new php_pear LWRP.  For example, the functionality of the `module_memcache` recipe can be enabled in the following ways:

    # using apt
    package "php5-memcache" do
      action :install
    end
    
    # using pear LWRP
    php_pear "memcache" do
      action :install
    end

---
Usage
=====

Simply include the `php` recipe where ever you would like php installed.  To install from source override the `node['php']['install_method']` attribute with in a role:

    name "php"
    description "Install php from source"
    override_attributes(
      "php" => {
        "install_method" => "source"
      }
    )
    run_list(
      "recipe[php]"
    )

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
