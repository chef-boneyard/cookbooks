maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs zsh"
version           "0.7.1"

recipe "zsh", "Installs zsh"

%w{ubuntu debian}.each do |os|
  supports os
end
