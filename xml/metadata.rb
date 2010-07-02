maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs xml"
version          "0.1.1"

recipe "xml", "Installs libxml development packages"

%w{ centos redhat suse fedora ubuntu debian }.each do |os|
  supports os
end
