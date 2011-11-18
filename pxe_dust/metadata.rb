maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Configures installing operating systems with preseed and kickstart files via PXE booting."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.2"
depends          "apache2"
depends          "tftp"

%w{ ubuntu debian }.each do |os|
  supports os
end
