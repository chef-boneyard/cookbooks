maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs ruby packages"
version           "0.7.3"

recipe "ruby", "Installs ruby packages"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
