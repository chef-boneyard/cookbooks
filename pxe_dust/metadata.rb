maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "Configures installing Ubuntu with preseed files via PXE booting."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0"
depends          "apache2"

#tested with Ubuntu, assume Debian works similarly 
%w{ ubuntu }.each do |os|
  supports os
end
