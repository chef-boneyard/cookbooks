maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures gems"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "gems::server"

attribute         "server",
  :display_name => "",
  :description => "",
  :recipes => [ "gems" ],
  :default => ""
