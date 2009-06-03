maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures mysql"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "mysql::client"
recipe            "mysql::server"

attribute         "mysql_ec2",
  :display_name => "",
  :description => "",
  :recipes => [ "mysql" ],
  :default => ""

attribute         "server",
  :display_name => "",
  :description => "",
  :recipes => [ "mysql" ],
  :default => ""
