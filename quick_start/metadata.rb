maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures quick_start"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "quick_start",
  :display_name => "",
  :description => "",
  :recipes => [ "quick_start" ],
  :default => ""
