maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs man-db"
version           "0.7"

%w{ debian ubuntu }.each do |os|
  supports os
end
