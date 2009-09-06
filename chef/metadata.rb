maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures chef client and server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.12"
recipe            "chef::client", "Sets up a client to talk to a chef-server"
recipe            "chef::server", "Configures a chef-server as a passenger application"

%w{ runit packages couchdb stompserver apache2 passenger_apache2 }.each do |cb|
  depends cb
end

%w{ centos rhel ubuntu debian }.each do |os|
  supports os
end

attribute "chef/path",
  :display_name => "Chef Path",
  :description => "Filesystem location for Chef files",
  :default => "/srv/chef"

attribute "chef/run_path",
  :display_name => "Chef Run Path",
  :description => "Filesystem location for Chef 'run' files",
  :default => "/var/run/chef"

attribute "chef/client_version",
  :display_name => "Chef Client Version",
  :description => "Set the version of the client gem to install",
  :default => "0.7.10"

attribute "chef/client_interval",
  :display_name => "Chef Client Interval ",
  :description => "Poll chef client process to run on this interval in seconds",
  :default => "1800"

attribute "chef/client_splay",
  :display_name => "Chef Client Splay ",
  :description => "Random number of seconds to add to interval",
  :default => "20"

attribute "chef/client_log",
  :display_name => "Chef Client Log",
  :description => "Location of the chef client log",
  :default => "STDOUT"

attribute "chef/indexer_log",
  :display_name => "Chef Indexer Log ",
  :description => "Location of the chef-indexer log",
  :default => "/var/log/chef/indexer.log"

attribute "chef/server_version",
  :display_name => "Chef Server Version",
  :description => "Set the version of the server and server-slice gems to install",
  :default => "0.7.10"

attribute "chef/server_log",
  :display_name => "Chef Server Log",
  :description => "Location of the Chef server log",
  :default => "/var/log/chef/server.log"

attribute "chef/server_path",
  :display_name => "Chef Server Path",
  :description => "Location of the Chef Server assets",
  :default => "gem_dir/gems/chef-server-chef_server_version"

attribute "chef/server_hostname",
  :display_name => "Chef Server Hostname",
  :description => "Hostname for the chef server, for building FQDN",
  :default => "hostname"

attribute "chef/server_fqdn",
  :display_name => "Chef Server Fully Qualified Domain Name",
  :description => "FQDN of the Chef server for Apache vhost and SSL certificate and clients",
  :default => "hostname.domain"

attribute "chef/server_ssl_req", 
  :display_name => "Chef Server SSL Request",
  :description => "Data to pass for creating the SSL certificate",
  :default => "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=chef_server_fqdn/emailAddress=ops@domain"

attribute "chef/server_token",
  :display_name => "Chef Server Validation Token",
  :description => "Value of the validation_token",
  :default => "randomly generated"

