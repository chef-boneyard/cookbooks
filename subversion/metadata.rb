maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs subversion"
version           "1.0.0"

%w{ redhat centos fedora ubuntu debian windows }.each do |os|
  supports os
end

depends "apache2"
depends "windows"

recipe "subversion", "Includes the client recipe."
recipe "subversion::client", "Subversion Client installs subversion and some extra svn libs"
recipe "subversion::server", "Subversion Server (Apache2 mod_dav_svn)"
