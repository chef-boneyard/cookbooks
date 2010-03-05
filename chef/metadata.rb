maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures chef client and server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.16.1"
recipe            "chef::client", "Sets up a client to talk to a chef-server"
recipe            "chef::server", "Configures a chef API server as a merb application"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit couchdb rabbitmq_chef apache2 openssl zlib xml java }.each do |cb|
  depends cb
end
