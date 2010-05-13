maintainer       "Opscode"
maintainer_email "joshua@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures reprepro for an apt repository"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

depends "build-essential"
depends "apache2"
