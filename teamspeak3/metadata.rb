maintainer       "Opscode"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs and starts teamspeak3 as a runit service."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

depends "runit"
