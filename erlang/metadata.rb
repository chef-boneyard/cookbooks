maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs erlang, optionally install GUI tools."
version           "0.8.3"

recipe "erlang", "Installs erlang"

%w{ ubuntu debian arch }.each do |os|
  supports os
end
