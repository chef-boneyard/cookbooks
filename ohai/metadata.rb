maintainer       "Opscode, Inc"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Distributes a directory of custom ohai plugins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.9.0"
recipe "ohai::default", "Distributes a directory of custom ohai plugins"
