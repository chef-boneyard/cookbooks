maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures jira"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "jira",
  :display_name => "",
  :description => "",
  :recipes => [ "jira" ],
  :default => ""
