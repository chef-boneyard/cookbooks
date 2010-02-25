maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nagios"
version           "0.3"

%w{ debian ubuntu }.each do |os|
  supports os
end
