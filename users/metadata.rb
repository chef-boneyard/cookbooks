maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Creates users from a databag search"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.1"
recipe "users::sysadmin", "searches users data bag for sysadmins and creates users"
