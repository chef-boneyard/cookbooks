maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs lvm2 package"
version           "0.7"

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end
