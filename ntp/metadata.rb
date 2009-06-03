maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures ntp"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "ntp",
  :display_name => "",
  :description => "",
  :recipes => [ "ntp" ],
  :default => ""
