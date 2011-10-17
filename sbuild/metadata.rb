maintainer       "Opscode"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Creates an sbuild host for debian packages."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.3"

depends "xfs"
depends "lvm"

recipe "sbuild", "Installs packages for building Debian packages with sbuild"
recipe "sbuild::schroots", "Sets up logical volumes for sbuild chroots for sid, karmic and lucid"
