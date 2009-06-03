maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures djbdns"
long_description  "Configures#{cookbook.name}"
version           "0.7"
recipe            "djbdns::axfr"
recipe            "djbdns::cache"
recipe            "djbdns::internal_server"
recipe            "djbdns::server"

attribute         "djbdns",
  :display_name => "",
  :description => "",
  :recipes => [ "djbdns" ],
  :default => ""
