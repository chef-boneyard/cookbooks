maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures redmine as a Rails app in passenger+apache2"
version           "0.10"

%w{ apache2 rails passenger_apache2 mysql sqlite }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end
