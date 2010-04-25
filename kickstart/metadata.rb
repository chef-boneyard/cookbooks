maintainer       "Opscode"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Creates apache2 vhost and serves a kickstart file."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"
depends "apache2"
supports "redhat"
supports "centos"
