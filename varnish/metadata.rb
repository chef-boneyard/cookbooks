maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Instsalls and configures varnish"
version           "0.8"

recipe "varnish", "Installs and configures varnish"

%w{ubuntu debian}.each do |os|
  supports os
end
