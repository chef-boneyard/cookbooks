maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures apache2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "apache2::mod_alias"
recipe            "apache2::mod_auth_basic"
recipe            "apache2::mod_auth_digest"
recipe            "apache2::mod_authn_file"
recipe            "apache2::mod_authnz_ldap"
recipe            "apache2::mod_authz_groupfile"
recipe            "apache2::mod_authz_host"
recipe            "apache2::mod_authz_user"
recipe            "apache2::mod_autoindex"
recipe            "apache2::mod_cgi"
recipe            "apache2::mod_dav"
recipe            "apache2::mod_dav_svn"
recipe            "apache2::mod_deflate"
recipe            "apache2::mod_dir"
recipe            "apache2::mod_env"
recipe            "apache2::mod_expires"
recipe            "apache2::mod_fcgid"
recipe            "apache2::mod_headers"
recipe            "apache2::mod_ldap"
recipe            "apache2::mod_log_config"
recipe            "apache2::mod_mime"
recipe            "apache2::mod_negotiation"
recipe            "apache2::mod_php5"
recipe            "apache2::mod_proxy"
recipe            "apache2::mod_proxy_http"
recipe            "apache2::mod_python"
recipe            "apache2::mod_rails"
recipe            "apache2::mod_rewrite"
recipe            "apache2::mod_setenvif"
recipe            "apache2::mod_ssl"
recipe            "apache2::mod_status"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

attribute "apache",
  :display_name => "Apache Hash",
  :description => "Hash of Apache attributes",
  :type => "hash"

attribute "apache/dir",
  :display_name => "Apache Directory",
  :description => "Location for Apache configuration",
  :default => "/etc/apache2"

attribute "apache/log_dir",
  :display_name => "Apache Log Directory",
  :description => "Location for Apache logs",
  :default => "/etc/apache2"

attribute "apache/user",
  :display_name => "Apache User",
  :description => "User Apache runs as",
  :default => "www-data"

attribute "apache/binary",
  :display_name => "Apache Binary",
  :description => "Apache server daemon program",
  :default => "/usr/sbin/apache2"

attribute "apache/icondir", 
  :display_name => "Apache Icondir",
  :description => "Directory location for icons",
  :default => "/usr/share/apache2/icons"

attribute "apache/listen_ports",
  :display_name => "Apache Listen Ports",
  :description => "Ports that Apache should listen on",
  :type => "array",
  :default => [ "80", "443" ]

attribute "apache/contact",
  :display_name => "Apache Contact",
  :description => "Email address of webmaster",
  :default => "ops@example.com"

attribute "apache/timeout",
  :display_name => "Apache Timeout",
  :description => "Connection timeout value",
  :default => "300"

attribute "apache/keepalive",
  :display_name => "Apache Keepalive",
  :description => "HTTP persistent connections",
  :default => "On"

attribute "apache/keepaliverequests",
  :display_name => "Apache Keepalive Requests",
  :description => "Number of requests allowed on a persistent connection",
  :default => "100"

attribute "apache/keepalivetimeout",
  :display_name => "Apache Keepalive Timeout",
  :description => "Time to wait for requests on persistent connection",
  :default => "5"

attribute "apache/servertokens",
  :display_name => "Apache Server Tokens",
  :description => "Server response header",
  :default => "Prod"

attribute "apache/serversignature"
  :display_name => "Apache Server Signature",
  :description => "Configure footer on server-generated documents",
  :default => "On"

attribute "apache/traceenable",
  :display_name => "Apache Trace Enable",
  :description => "Determine behavior of TRACE requests",
  :default => "On"

attribute "apache/prefork",
  :display_name => "Apache Prefork",
  :description => "Hash of Apache prefork tuning attributes.",
  :type => "hash"

attribute "apache/prefork/startservers",
  :display_name => "Apache Prefork MPM StartServers",
  :description => "Number of MPM servers to start",
  :default => "16"

attribute "apache/prefork/minspareservers",
  :display_name => "Apache Prefork MPM MinSpareServers",
  :description => "Minimum number of spare server processes",
  :default => "16"

attribute "apache/prefork/maxspareservers",
  :display_name => "Apache Prefork MPM MaxSpareServers",
  :description => "Maximum number of spare server processes",
  :default => "32"

attribute "apache/prefork/serverlimit",
  :display_name => "Apache Prefork MPM ServerLimit",
  :description => "Upper limit on configurable server processes",
  :default => "400"

attribute "apache/prefork/maxclients",
  :display_name => "Apache Prefork MPM MaxClients",
  :description => "Maximum number of simultaneous connections",
  :default => "400"

attribute "apache/prefork/maxrequestsperchild",
  :display_name => "Apache Prefork MPM MaxRequestsPerChild",
  :description => "Maximum number of request a child process will handle",
  :default => "10000"

attribute "apache/worker",
  :display_name => "Apache Worker",
  :description => "Hash of Apache prefork tuning attributes.",
  :type => "hash"

attribute "apache/worker/startservers",
  :display_name => "Apache Worker MPM StartServers",
  :description => "Initial number of server processes to start",
  :default => "4"

attribute "apache/worker/maxclients",
  :display_name => "Apache Worker MPM MaxClients",
  :description => "Maximum number of simultaneous connections",
  :default => "1024"

attribute "apache/worker/minsparethreads",
  :display_name => "Apache Worker MPM MinSpareThreads",
  :description => "Minimum number of spare worker threads",
  :default => "64"

attribute "apache/worker/maxsparethreads",
  :display_name => "Apache Worker MPM MaxSpareThreads",
  :description => "Maximum number of spare worker threads",
  :default => "192"

attribute "apache/worker/threadsperchild",
  :display_name => "Apache Worker MPM ThreadsPerChild",
  :description => "Constant number of worker threads in each server process",
  :default => "64"

attribute "apache/worker/maxrequestsperchild",
  :display_name => "Apache Worker MPM MaxRequestsPerChild",
  :description => "Maximum number of request a child process will handle",
  :default => "0"
