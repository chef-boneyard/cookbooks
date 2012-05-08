maintainer        "Padraig O'Sullivan"
maintainer_email  "osullivan.padraig@gmail.com"
license           "Apache 2.0"
description       "Installs and configures drizzle for client or server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.1.0"
recipe            "drizzle", "Includes the client recipe to configure a client"
recipe            "drizzle::client", "Installs packages required for drizzle clients using run_action magic"
recipe            "drizzle::server", "Installs packages required for drizzle servers"

%w{ debian ubuntu centos suse fedora redhat}.each do |os|
  supports os
end

attribute "drizzle/bind_address",
  :display_name => "Drizzle Bind Address",
  :description => "Address that drizzled should listen on",
  :default => "ipaddress"

attribute "drizzle/datadir",
  :display_name => "Drizzle Data Directory",
  :description => "Location of drizzle databases",
  :default => "/var/lib/drizzle"

attribute "drizzle/tunable",
  :display_name => "Drizzle Tunables",
  :description => "Hash of Drizzle tunable attributes",
  :type => "hash"

