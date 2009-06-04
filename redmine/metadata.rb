maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures redmine as a Rails app in passenger"
version           "0.7"

%w{ apache2 rails passenger mysql sqlite }.each do |cb|
  depends cb
end
