maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures maradns"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "maradns",
  :display_name => "",
  :description => "",
  :recipes => [ "maradns" ],
  :default => ""
