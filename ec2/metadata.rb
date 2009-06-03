maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures ec2"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "ec2_metadata",
  :display_name => "",
  :description => "",
  :recipes => [ "ec2" ],
  :default => ""

attribute         "ec2_recipe_options",
  :display_name => "",
  :description => "",
  :recipes => [ "ec2" ],
  :default => ""
