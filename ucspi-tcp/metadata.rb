maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs ucspi-tcp"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe "ucspi-tcp", "Installs ucspi-tcp"

%w{ build-essential }.each do |cb|
  depends cb
end

%w{ ubuntu debian centos rhel arch }.each do |os|
  supports os
end
