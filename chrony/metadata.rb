maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures chrony, an application used to maintain the accuracy of the system clock (similar to NTP)."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ debian ubuntu }.each do |os|
  supports os
end
