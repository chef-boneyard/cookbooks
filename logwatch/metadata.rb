maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs logwatch, a nice log analyzer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.1"

depends "perl"

recipe "logwatch", "Installs logwatch"

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end
