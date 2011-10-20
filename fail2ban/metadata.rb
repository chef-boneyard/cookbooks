maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures fail2ban"
version           "1.0.0"

recipe "fail2ban", "Installs and configures fail2ban"

%w{ ubuntu debian }.each do |os|
  supports os
end
