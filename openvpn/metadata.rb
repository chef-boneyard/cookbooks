maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures openvpn and includes rake tasks for managing certs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end

attribute "openvpn/local",
  :display_name => "OpenVPN Local",
  :description => "Local interface (ip) to listen on",
  :default => "ipaddress"

attribute "openvpn/proto",
  :display_name => "OpenVPN Protocol",
  :description => "UDP or TCP",
  :default => "udp"

attribute "openvpn/type",
  :display_name => "OpenVPN Type",
  :description => "Server or server-bridge",
  :default => "server"

attribute "openvpn/subnet",
  :display_name => "OpenVPN Subnet",
  :description => "Subnet to hand out to clients",
  :default => "10.8.0.0"

attribute "openvpn/netmask",
  :display_name => "OpenVPN Netmask",
  :description => "Netmask for clients",
  :default => "255.255.0.0"

