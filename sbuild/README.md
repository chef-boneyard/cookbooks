Notice
======

This cookbook uses LVM directly. Please understand what the recipe and
definition do before using it on your system. It has been tested on
Debian sid (unstable) only!

That said, the packages hosted by Opscode on apt.opscode.com were
built on a system using this cookbook :-).

Description
===========

Installs and configures a server to be an 'sbuild' system to build
debian packages from source. Provides a definition that will create
logical volumes for snapshot use.

Requirements
============

Chef 0.8.x+ is required for data bag use (see below).

## Platform:

This cookbook is very much Debian / Ubuntu specific. It has been
tested mainly on Debian sid/unstable.

## Cookbooks:

* xfs
* lvm

## Server Configuration

This cookbook utilizes a 'users' data bag. The requirement here is for
any users that will perform sbuilds have a groups attribute 'sbuild'.

    knife data bag show users
    [
      "jtimberman"
    ]

    knife data bag show users jtimberman
    {
      "id": "jtimberman",
      "groups": "sbuild"
    }

This will allow the cookbook to create user specific settings.

You must create a volume group on your build server that will contain
the logical volumes for sbuild's schroots. The default in the
sbuild_lv define is 'buildvg', but you can name it whatever you like.
See USAGE, below.

Attributes
==========

All attributes are under the node[:sbuild] space.

* mailto - address to send mail about sbuilds, default 'root'.
* key_id - sets the PGP key ID to use, default "".
* pgp_options - default options for PGP, but commented out in config file (use debsign).
* maintainer_name - package maintainer name, default "".
* lv_size - size of logical volumes to create, default "5G" (should be enough for most systems).
* snapshot_size - size of snapshots for schroots, default "4G" (should be enough for most systems).

Usage
=====

The default recipe will install a number of useful packages for
building debian packages from source. It will also make sure the
device mapper kernel module is loaded for LVM, create some nice
configuration for users who are in the 'sbuild' group (see above about
data bags). Finally, it will create a script to perform automated
updates to schroot sources, to ensure your debootstrapped build
environments have the latest packages.

The schroots recipe contains some commented examples of using the
sbuild_lv definition.

The sbuild_lv definition does the heavy lifting. Here's an example,
and what it does:

    sbuild_lv "lucid" do
      release "lucid"
      distro "ubuntu"
      vg "buildvg"
    end

This will:

* Create a logical volume named after the `sbuild_lv` (lucid) in the
  vg (buildvg), size will be `lv_size` (5G).
* Create an XFS filesystem on the logical volume. Replace the 'execute
  mkfs.xfs' resource in the definition to use another filesystem if
  you prefer.
* Create an schroot configuration for the named sbuild_lv
  (/etc/schroot/chroot.d/lucid).
* Create a script that needs to be executed to finish setup of the
  schroot (/usr/local/bin/mk_chroot_lucid.sh).

The mk_chroot script should then be executed to finish creating the
schroot. Since this does a debootstrap (debian installation), we don't
run it within Chef, as it can be very time consuming to execute. The
script itself performs the following:

* Mounts the volume.
* Runs debootstrap for the specified distro and release.
* Sets up the APT sources.list to use in the schroot.
* Creates a '/finish.sh' script in the schroot that gets a few more
  release specific packages.
* Runs the '/finish.sh' within the schroot.
* Prints some usage information on how to use the schroot it just
  created.

Additional Resources
====================

Some resources that are helpful in building debian/ubuntu packages
with sbuild:

http://www.pseudorandom.co.uk/2007/sbuild/
http://www.pseudorandom.co.uk/2008/sbuild-dm/
https://help.ubuntu.com/community/SbuildLVMHowto

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
