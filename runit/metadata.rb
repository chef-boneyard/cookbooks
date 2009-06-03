maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures runit"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "sv_bin",
  :display_name => "",
  :description => "",
  :recipes => [ "runit" ],
  :default => ""
