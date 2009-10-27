maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs rsync"
version           "0.7"

%w{ centos fedora redhat ubuntu debian }.each do |os|
  supports os
end
