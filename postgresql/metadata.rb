maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures postgresql for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"
recipe            "postgresql::client", "Installs postgresql client package(s)"
recipe            "postgresql::server", "Installs postgresql server packages, templates"

%w{rhel centos ubuntu debian}.each do |os|
  supports os
end

attribute "postgresql/dir",
  :display_name => "PostgreSQL Directory",
  :description => "Location of the PostgreSQL databases",
  :default => "/etc/postgresql/8.3/main"

