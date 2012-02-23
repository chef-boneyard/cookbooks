maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures apt and apt services and an LWRP for managing apt repositories"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.3.2"
recipe            "apt", "Runs apt-get update during compile phase and sets up preseed directories"
recipe            "apt::cacher-ng", "Set up an apt-cacher-ng caching proxy"
recipe            "apt::cacher-client", "Client for the apt::cacher-ng caching proxy"

%w{ ubuntu debian }.each do |os|
  supports os
end
