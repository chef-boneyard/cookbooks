maintainer       "Opscode"
maintainer_email "joshua@opscode.com"
license          "Apache 2.0"
description      "Creates an sbuild host for debian packages."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

depends "xfs"
depends "lvm"
