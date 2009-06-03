maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures postgresql"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "postgresql::client"
recipe            "postgresql::server"

attribute         "postgresql",
  :display_name => "",
  :description => "",
  :recipes => [ "postgresql" ],
  :default => ""
