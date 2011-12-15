DESCRIPTION
===========

Installs tar and a resource for source package compilation.

LICENSE AND AUTHOR
==================

Author:: Nathan L Smith (<nathan@cramerdev.com>)

Copyright 2011, Cramer Development, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Resources/Providers
===================

A `tar_package` LWRP provides an easy way to download remote files and compile and install them.

This only works for the most basic Autoconf programs that can do `./configure && make && make install`.

# Actions

- :install: Installs the package

# Attribute Parameters

- source: name attribute. The source remote URL.
- prefix: Directory to be used as the `--prefix` configure flag.
- source\_directory: Directory to which source files are download.
- creates: A file this command creates - if the file exists, the command will not be run.
- configure\_flags: Array of additional flags to be passed to `./configure`.

# Example

    tar_package 'http://pgfoundry.org/frs/download.php/1446/pgpool-3.4.1.tar.gz' do
      prefix '/usr/local'
      creates '/usr/local/bin/pgpool'
    end

This will download, compile, and install the package from the given URL and install it into /usr/local.
