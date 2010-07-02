maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs but does not configure drbd"
version           "0.7.1"
depends           "lvm"
recipe "drbd", "Installs drbd"

%w{ ubuntu debian}.each do |os|
  supports os
end
