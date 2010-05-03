maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures a server to be an OpenLDAP master, replication slave or client for auth"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"
recipe            "openldap::auth", "Set up openldap for user authentication"
recipe            "openldap::client", "Install openldap client packages"
recipe            "openldap::server", "Set up openldap to be a slapd server"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ openssh nscd }.each do |cb|
  depends cb
end

attribute "openldap/basedn",
  :display_name => "OpenLDAP BaseDN",
  :description => "BaseDN for the LDAP directory",
  :default => "dc=domain,dc=com"

attribute "openldap/server",
  :display_name => "OpenLDAP Server",
  :description => "LDAP Server, used for URIs",
  :default => "ldap.domain"

attribute "openldap/rootpw",
  :display_name => "OpenLDAP Root Password",
  :description => "Password for 'admin' root user, should be a SHA hash that OpenLDAP supports",
  :default => "nil"

attribute "openldap/dir",
  :display_name => "OpenLDAP Dir",
  :description => "Main configuration directory for OpenLDAP",
  :default => "/etc/ldap"

attribute "openldap/run_dir",
  :display_name => "OpenLDAP Run Directory",
  :description => "Run directory for LDAP server processes",
  :default => "/var/run/slapd"

attribute "openldap/module_dir",
  :display_name => "OpenLDAP Module Directory",
  :description => "Location for OpenLDAP add-on modules",
  :default => "/usr/lib/ldap"

attribute "openldap/ssl_dir",
  :display_name => "OpenLDAP SSL Directory",
  :description => "Location for LDAP SSL certificates",
  :default => "openldap_dir/ssl"

attribute "openldap/cafile",
  :display_name => "OpenLDAP CA File",
  :description => "Location for CA certificate",
  :default => "openldap_dir_ssl/ca.crt"

attribute "openldap/slapd_type",
  :display_name => "OpenLDAP Slapd Type",
  :description => "Whether the server is a master or slave",
  :default => "nil"

attribute "openldap/slapd_master",
  :display_name => "OpenLDP Slapd Master",
  :description => "Search nodes for attribute slapd_type master, for slaves",
  :default => "nil"

attribute "openldap/slapd_replpw",
  :display_name => "OpenLDAP Slapd Replication Password",
  :description => "Password for slaves to replicate from master",
  :default => "nil"

attribute "openldap/slapd_rid",
  :display_name => "OpenLDAP Slapd Replication ID",
  :description => "Slave's ID, must be unique",
  :default => "102"

attribute "openldap/auth_type",
  :display_name => "OpenLDAP Auth Type",
  :description => "Used in Apache configs, AuthBasicProvider",
  :default => "openldap"

attribute "openldap/auth_binddn",
  :display_name => "OpenLDAP Auth BindDN",
  :description => "Used in auth_url and Apache configs, AuthBindDN",
  :default => "ou=people,openldap_basedn"

attribute "openldap/auth_bindpw",
  :display_name => "OpenLDAP Auth Bind Password",
  :description => "Used in Apache configs, AuthBindPassword",
  :default => "nil"

attribute "openldap/auth_url",
  :display_name => "OpenLDAP Auth URL",
  :description => "Used in Apache configs, AuthLDAPURL",
  :default => "ldap://openldap_server/openldap_auth_binddn?uid?sub?(objectClass=*)"

