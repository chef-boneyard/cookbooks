maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs perl and provides a define for maintaining CPAN modules"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"

%w{ ubuntu debian centos redhat }.each do |os|
  supports os
end
