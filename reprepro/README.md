DESCRIPTION
===========

Sets up an APT repository suitable for using the reprepro tool to
manage distributions and components.

See the reprepro documentation for more information about reprepro
itself, including the man(1) page in the package.

* http://mirrorer.alioth.debian.org/

REQUIREMENTS
============

Platform: Debian or Ubuntu.

Requires Chef 0.8.x+, client/server. Does not work with Chef Solo due
to data bag use.

You'll need to generate the PGP key separately and provide the data in
the databag.

USAGE
=====

Attributes
----------

Attributes in this cookbook are set via the default recipe with data
from the data bag. The following attributes are used, in the
`reprepro` namespace.

* `fqdn` - the fqdn that would go in sources.list
* `description` - a description of the repository
* `pgp_email` - the email address of the pgp key
* `pgp_fingerprint` - the finger print of the pgp key

Data Bag
--------

Create a data bag to store the repository information. It should be
named `reprepro`. The recipe uses the `main` data bag item.

    {
      "id": "main",
      "fqdn": "apt.example.com",
      "repo_dir": "/srv/apt",
      "incoming": "/srv/apt_incoming",
      "description": "APT Repository for our packages.",
      "codenames": [
        "lucid", "hardy", "sid", "squeeze", "lenny"
      ],
      "allow": [
        "unstable>sid", "stable>squeeze"
      ]
      "pgp": {
        "email": "packages@example.com",
        "fingerprint": "PGP Fingerprint for the key",
        "public": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n-----END PGP PUBLIC KEY BLOCK-----\n",
        "private": "-----BEGIN PGP PRIVATE KEY BLOCK-----\n-----END PGP PRIVATE KEY BLOCK-----\n"
      },
      "pulls": {
        "name": "sid",
        "from": "sid",
        "component": "main"
      },
      "architectures": [
        "amd64","i386","all","source"
      ]
    }

* `fqdn`: the fully qualified domain name of the apt server, used in
  in the Apache vhost template and as the Origin in the distributions
  configuration. Also saved to the node as
  `node['reprepro']['fqdn]`.
* `repo_dir`: directory on disk where reprepro will serve the packages
* `incoming`: the incoming directory, used in the incoming
  configuration.
* `description`: description about the repository, also saved to the
  node as `node['reprepro']['description']`.
* `codenames`: array of codenames to set up for the repository, used
  with allow for the Allow directive in the incoming configuration
* `allow`: [optional] array of additional codenames to use in the incoming
  configuration
* `pgp`: hash of options for the pgp setup. the 
* `pgp['email']`: email address of the signing key
* `pgp['fingerprint]`: fingerprint of the PGP key
* `pgp['public]`: the public PGP key, should be a single line
  (replace line endings with \n)
* `pgp['private]`: the private PGP key, should be a single line
  (replace line endings with \n)
* `pulls`: hash used in the pulls configuration.
* `architectures`: array of architectures to create in distributions configuration

Changes
=======

## v0.2.4:

* [COOK-922] - add `allow` to data bag
* Update the readme with data bag info

LICENSE AND AUTHOR
==================

Author: Joshua Timberman (<joshua@opscode.com>)

Copyright 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
