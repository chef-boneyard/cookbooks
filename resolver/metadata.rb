maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures resolver"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "resolver",
  :display_name => "",
  :description => "",
  :recipes => [ "resolver" ],
  :default => ""
