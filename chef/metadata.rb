maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures Chef for chef-client and chef-server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.1"
recipe            "chef", "Default recipe is empty, use one of the other recipes."
recipe            "chef::client", "Sets up a client to talk to a chef-server"
recipe            "chef::client_service", "Sets up a client daemon to run periodically"
recipe            "chef::bootstrap_client", "Set up rubygem installed chef client"
recipe            "chef::delete_validation", "Deletes validation.pem after client registers"
recipe            "chef::server", "Configures a chef API server as a merb application"
recipe            "chef::bootstrap_server", "Set up rubygem installed chef server"
recipe            "chef::server_proxy", "Configures Apache2 proxy for API and WebUI"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit bluepill daemontools couchdb rabbitmq_chef apache2 openssl zlib xml java }.each do |cb|
  depends cb
end
