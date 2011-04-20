Description
===========

Configures various YUM components on Red Hat-like systems.  Also includes a LWRP.

Requirements
============
RHEL or CentOS 5.x or newer. It has not been tested on other platforms or earlier versions. RHEL 6 support is untested (testing and patches are welcome).

Recipes
=======

default
-------
The default recipe runs `yum update` during the Compile Phase of the Chef run to ensure that the system's package cache is updated with the latest. It is recommended that this recipe appear first in a node's run list (directly or through a role) to ensure that when installing packages, Chef will be able to download the latest version available on the remote YUM repository.

Resources/Providers
===================

This LWRP provides an easy way to manage additional YUM repositories.

# Actions

- :add: creates a repository file and builds the repository listing
- :remove: removes the repository file

# Attribute Parameters

- repo_name: name attribute. The name of the channel to discover
- uri: the base of the Debian distribution
- distribution: this is usually your release's codename...ie something like `karmic`, `lucid` or `maverick`
- components: package groupings..when it doubt use `main`
- deb_src: whether or not to add the repository as a source repo as well
- key_server: the GPG keyserver where the key for the repo should be retrieved
- key: if a `key_server` is provided, this is assumed to be the fingerprint, otherwise it is the URI to the GPG key for the repo

# Example

    # add the Zenoss repo
    apt_repository "zenoss" do
      uri "http://dev.zenoss.org/deb"
      components ["main","stable"]
      action :add
    end
    
    # add the Nginx PPA; grab key from keyserver
    apt_repository "nginx-php" do
      uri "http://ppa.launchpad.net/nginx/php5/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "C300EE8C"
      action :add
    end
    
    # add the Cloudkick Repo
    apt_repository "cloudkick" do
      uri "http://packages.cloudkick.com/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      key "http://packages.cloudkick.com/cloudkick.packages.key"
      action :add
    end
    
    # remove Zenoss repo
    apt_repository "zenoss" do
      action :remove
    end
    
Usage
=====

Put `recipe[yum]` first in the run list to ensure `yum update` is run before other recipes.

License and Author
==================

Author:: Eric G. Wolfe
Author:: Matt Ray (<matt@opscode.com>)
Copyright:: 2010-2011
Copyright:: 2011 Opscode, Inc.
Contributor:: Tippr, Inc.
Copyright:: 2011 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

