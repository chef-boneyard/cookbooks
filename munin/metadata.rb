maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Instsalls and configures munin"
version           "0.9.1"

depends "apache2"
supports "debian"
supports "ubuntu"

recipe "munin", "Empty, use one of the other recipes"
recipe "munin::client", "Instlls munin and configures a client by searching for the server, which should have a role named monitoring"
recipe "munin::server", "Installs munin and configures a server, node should have the role 'monitoring' so clients can find it"
