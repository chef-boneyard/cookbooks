maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs sqlite"
version           "0.7"

%w{ubuntu debian}.each do |os|
  supports os
end
