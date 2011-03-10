maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nagios"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.4.5"

recipe "nagios", "Includes the client recipe."
recipe "nagios::client", "Installs and configures a nagios client with nrpe"
recipe "nagios::server", "Installs and configures a nagios server"
recipe "nagios::nsca-server", "Install and configure the NSCA daemon"
recipe "nagios::nsca-client", "Install and configure the NSCA client"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "apache2"
depends "openssl"
depends "cluster_service_discovery"
depends "sudo"
