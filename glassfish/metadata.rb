maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures Glassfish"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"
recipe            "glassfish", "Main Glassfish configuration"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end
