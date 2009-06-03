maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures packages"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "packages",
  :display_name => "",
  :description => "",
  :recipes => [ "packages" ],
  :default => ""
