maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs java via openjdk."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.10.1"

%w{ debian ubuntu redhat centos fedora }.each do |os|
  supports os
end
