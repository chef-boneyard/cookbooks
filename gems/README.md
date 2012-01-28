Description
===========

Sets up a local gem server repository.

Changes
=======

## v1.0.0:

* Current public release.

Requirements
============

## Platform:

* Ubuntu 9.04, 8.10

## Cookbooks:

* apache2
* rsync

Attributes
==========

* `gem_server[:virtual_host_name]` - ServerName for Apache vhost.
  Default 'gems.domain'.
* `gem_server[:virtual_host_alias]` - ServerAlias(es) for Apache vhost.
  Default 'gems'.
* `gem_server[:directory]` - Filesystem location for the repository,
  default is /srv/gems.

Usage
=====

Create files/default/packages, and copy gems to that directory.

Specify the gem source on clients via the command line, for example:

    sudo gem source -a http://gems
    sudo gem install rails --source http://gems

Or use the source with gem_package resources in your chef recipes.

    gem_package "rails" do
      source "http://gems"
    end

Use the gems::mirror recipe to mirror RubyForge. This will take a long time because the repository is 28k+ gems and over 5.5G. It will also override the remote_directory resource to not notify gem generate_index, and instead handle that in the cron job that does the rsync.

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
