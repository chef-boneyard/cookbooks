maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures daemontools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.9.0"
recipe "daemontools", "Installs daemontools by source or package depending on platform"

%w{ build-essential ucspi-tcp }.each do |cb|
  depends cb
end

%w{ debian ubuntu arch }.each do |os|
  supports os
end
