maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures all aspects of tomcat6 using custom local installation"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.2"
recipe            "tomcat6", "Main Tomcat 6 configuration"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

attribute "tomcat6/with_native",
  :display_name => "Tomcat native support",
  :description => "works for centos, install tomcat-native libraries",
  :type => "string",
  :default => "false"
