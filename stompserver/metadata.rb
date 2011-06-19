maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs stompserver and sets up a service"
version           "1.0.0"

recipe "stompserver", "Installs stompserver and starts the service"

%w{ ubuntu debian centos fedora redhat }.each do |os|
  supports os
end
