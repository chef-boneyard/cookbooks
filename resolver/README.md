DESCRIPTION
===========

Configures /etc/resolv.conf.

USAGE
=====

Set the resolver attributes in a role, for example from my base.rb:

    "resolver" => {
      "nameservers" => ["10.13.37.120", "10.13.37.40"],
      "search" => "int.example.org"
    }

The resulting /etc/resolv.conf will look like:

    domain int.example.org
    search int.example.org
    nameserver 10.13.37.120
    nameserver 10.13.37.40

LICENSE AND AUTHOR
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
