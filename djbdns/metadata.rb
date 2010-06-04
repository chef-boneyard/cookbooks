maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs djbdns and configures DNS services"
version           "0.8"
recipe            "djbdns", "Installs djbdns from package or source and creates users"
recipe            "djbdns::axfr", "Sets up djbdns AXFR service"
recipe            "djbdns::cache", "Sets up public dnscache service"
recipe            "djbdns::internal_server", "Sets up internal TinyDNS"
recipe            "djbdns::server", "Sets up external TinyDNS"

%w{ build-essential runit }.each do |cb|
  depends cb
end

%w{ ubuntu debian centos rhel }.each do |os|
  supports os
end

attribute "djbdns/tinydns_ipaddress",
  :display_name => "DJB DNS TinyDNS IP Address",
  :description => "Specify the IP address for TinyDNS",
  :default => "127.0.0.1"

attribute "djbdns/tinydns_internal_ipaddress",
  :display_name => "DJB DNS TinyDNS Internal IP Address",
  :description => "Specify the IP address for internal TinyDNS",
  :default => "127.0.0.1"

attribute "djbdns/axfrdns_ipaddress",
  :display_name => "DJB DNS AXFR IP Address",
  :description => "Specify the IP address for AXFR service",
  :default => "127.0.0.1"

attribute "djbdns/public_dnscache_ipaddress",
  :display_name => "DJB DNS Public DNS Cache IP Address",
  :description => "Specify the IP address for the public dnscache",
  :default => "ipaddress"

attribute "djbdns/public_dnscache_allowed_networks",
  :display_name => "DJB DNS Public DNS Cache Allowed Networks",
  :description => "Networks allowed to query the public dnscache",
  :type => "array",
  :default => ["ipaddress.split('.')[0,2].join('.')"]

attribute "djbdns/tinydns_internal_resolved_domain",
  :display_name => "DJB DNS TinyDNS Internal Resolved Domain",
  :description => "Internal domain TinyDNS is resolver",
  :default => "domain"

attribute "djbdns/bin_dir",
  :display_name => "DJB DNS Binaries Directory",
  :description => "Location of the djbdns binaries",
  :default => "/usr/local/bin"

