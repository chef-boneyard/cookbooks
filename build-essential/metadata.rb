maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs C compiler / build tools"
version           "0.7"

%w{ centos ubuntu debian }.each do |os|
  supports os
end
