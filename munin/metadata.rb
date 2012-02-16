maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures munin"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.2"

depends "apache2", ">= 1.0.6"

%w{arch debian ubuntu redhat centos scientific fedora freebsd}.each do |os|
  supports os
end

recipe "munin", "Empty, use one of the other recipes"
recipe "munin::client", "Instlls munin and configures a client by searching for the server, which should have a role named monitoring"
recipe "munin::server", "Installs munin and configures a server, node should have the role 'monitoring' so clients can find it"
