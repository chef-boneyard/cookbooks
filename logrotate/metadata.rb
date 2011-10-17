maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Keeps logrotate package updated and has definition for logrotate configs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.8.2"

recipe "logrotate", "Keeps logrotate package updated"

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end
