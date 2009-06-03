maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures openldap"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "openldap::auth"
recipe            "openldap::client"
recipe            "openldap::server"

attribute         "openldap",
  :display_name => "",
  :description => "",
  :recipes => [ "openldap" ],
  :default => ""
