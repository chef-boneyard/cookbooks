maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs zlib"
version          "0.1"

%w{ centos redhat suse fedora ubuntu debian }.each do |os|
  supports os
end
