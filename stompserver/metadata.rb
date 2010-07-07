maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs stompserver and sets up a runit_service"
version           "0.7.1"

recipe "stompserver", "Installs and configures stompserver as a runit service"

%w{ packages runit }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end
