maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures radiant"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"

attribute         "radiant",
  :display_name => "",
  :description => "",
  :recipes => [ "radiant" ],
  :default => ""
