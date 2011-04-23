maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures the Cloudkick Agent"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.1"

depends "apt"
depends "yum"

recipe "cloudkick::default", "Installs and configures Cloudkick"

