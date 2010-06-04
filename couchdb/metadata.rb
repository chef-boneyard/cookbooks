maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs CouchDB package and starts service"
long_description  <<-EOH
Installs the CouchDB package if it is available from an package repository on
the node. If the package repository is not available, CouchDB needs to be 
installed via some other method, either a backported package, or compiled 
directly from source. CouchDB is available on Red Hat-based systems through
the EPEL Yum Repository.
EOH
version           "0.12"

depends           "erlang"
supports          "ubuntu", ">= 8.10" # for package in APT
supports          "debian", ">= 5.0" # for package in APT
supports          "openbsd"
supports          "freebsd"

%w{ rhel centos fedora }.each do |os|
  supports os # requires EPEL Yum Repository
end
