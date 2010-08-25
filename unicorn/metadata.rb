maintainer       "Opscode, Inc"
maintainer_email "ops@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures unicorn"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.3"
depends          "ruby"
depends          "rubygems"
recipe "unicorn", "Installs unicorn rubygem"
