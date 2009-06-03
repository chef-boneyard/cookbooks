maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures postfix"
long_description  "Configures#{cookbook.name}"
version           "0.7"
recipe            "postfix::sasl_auth"

attribute         "postfix",
  :display_name => "",
  :description => "",
  :recipes => [ "postfix" ],
  :default => ""
