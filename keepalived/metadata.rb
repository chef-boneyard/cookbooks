maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7.1"
supports          "ubuntu"

recipe "keepalived", "Installs and configures keepalived"
