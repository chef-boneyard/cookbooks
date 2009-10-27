maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs but does not configure heartbeat"
version           "0.7"
suggests          "drbd"

%w{ debian ubuntu }.each do |os|
  supports os
end
