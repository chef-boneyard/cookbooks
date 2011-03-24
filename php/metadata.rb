maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and maintains php and php modules"
version           "0.99.1"

depends "build-essential"
depends "xml"
depends "mysql"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "php", "Installs php"
recipe "python::package", "Installs php using packages."
recipe "python::source", "Installs php from source."