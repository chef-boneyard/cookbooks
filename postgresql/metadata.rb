maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures PostgreSQL for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.11.1"

recipe            "postgresql", "Empty, use one of the other recipes"
recipe            "postgresql::client", "Installs PostgreSQL client package(s)"
recipe            "postgresql::server", "Installs PostgreSQL server packages, templates"
recipe            "postgresql::server_redhat", "Installs PostgreSQL server packages, Red Hat family style"
recipe            "postgresql::server_server", "Installs PostgreSQL server packages, Debian family style"
recipe            "postgresql::postgis", "Installs PostGIS package(s)"

attribute "postgresql/listen",
 :display_name => "PostgreSQL listen address",
 :recipes => [ "server_debian", "server_redhat" ],
 :default => "localhost",
 :description => "The IP address for PostgreSQL to listen on."

attribute "postgresql/port",
 :display_name => "PostgreSQL port number",
 :recipes => [ "server_debian", "server_redhat" ],
 :default => 5432,
 :description => "The port number for PostgreSQL to use."

attribute "postgresql/dir",
 :display_name => "PostgreSQL configuration directory",
 :recipes => [ "server_debian", "server_redhat" ],
 :calculated => true,
 :description => "The location of PostgreSQL's configuration files."

attribute "postgresql/contrib_dir",
 :display_name => "PostgreSQL contrib directory",
 :calculated => true,
 :description => "The location of PostgreSQL's contrib scripts. Read-only, determined by platform."

attribute "postgresql/version",
 :display_name => "PostgreSQL version",
 :recipes => [ "server_debian", "server_redhat", "client", "postgis" ],
 :calculated => true,
 :description => "The version of PostgreSQL to use. Read-only, determined by platform."

attribute "postgresql/ssl",
 :display_name => "PostgreSQL SSL support",
 :calculated => true,
 :description => "Enable SSL support for PostgreSQL? This is false by default, except on Debian family platforms for 8.4 and above."

%w{rhel centos fedora ubuntu debian suse}.each do |os|
  supports os
end
