maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures nginx"
long_description  "Configures#{cookbook.name}"
version           "0.7"

attribute         "nginx_locations",
  :display_name => "",
  :description => "",
  :recipes => [ "nginx" ],
  :default => ""

attribute         "nginx_settings",
  :display_name => "",
  :description => "",
  :recipes => [ "nginx" ],
  :default => ""
