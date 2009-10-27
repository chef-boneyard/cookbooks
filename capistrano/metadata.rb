maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Capistrano gem and provides a define to set up deployment for an application"
version           "0.7"
recipe            "capistrano", "Installs Capistrano gem"
%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end
