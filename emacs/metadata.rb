maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs emacs"
version           "0.7"

recipe "emacs", "Installs Emacs"

%w{ ubuntu debian redhat centos }.each do |os|
  supports os
end
