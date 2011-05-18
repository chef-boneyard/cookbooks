maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures Chef Server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.11"
recipe            "chef_server", "Compacts the Chef Server CouchDB."
recipe            "chef_server::rubygems-install", "Set up rubygem installed chef server."
recipe            "chef_server::apache-proxy", "Configures Apache2 proxy for API and WebUI"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit bluepill daemontools couchdb  apache2 openssl zlib xml java gecode }.each do |cb|
  depends cb
end
