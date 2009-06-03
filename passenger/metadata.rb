maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures passenger"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"

attribute         "passenger",
  :display_name => "",
  :description => "",
  :recipes => [ "passenger" ],
  :default => ""
