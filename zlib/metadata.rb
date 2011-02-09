maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs zlib"
version          "0.1.2"

recipe "zlib", "Installs zlib development package"

%w{ centos redhat suse fedora ubuntu debian arch }.each do |os|
  supports os
end
