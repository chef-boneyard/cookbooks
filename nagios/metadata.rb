maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nagios"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.3.1"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "apache2"
