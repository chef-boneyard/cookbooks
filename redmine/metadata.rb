maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures redmine"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "redmine_settings",
  :display_name => "",
  :description => "",
  :recipes => [ "redmine" ],
  :default => ""
