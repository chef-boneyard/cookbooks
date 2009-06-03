maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures rsyslog"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "rsyslog::client"
recipe            "rsyslog::server"

attribute         "rsyslog",
  :display_name => "",
  :description => "",
  :recipes => [ "rsyslog" ],
  :default => ""
