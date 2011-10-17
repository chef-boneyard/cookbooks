maintainer       "Barry Steinglass"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures wordpress"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.8.2"

recipe "wordpress", "Installs and configures wordpress LAMP stack on a single system"

%w{ php openssl }.each do |cb|
  depends cb
end

depends "apache2", ">= 0.99.4"
depends "mysql", ">= 1.0.5"

%w{ debian ubuntu redhat centos fedora }.each do |os|
  supports os
end

attribute "wordpress/version",
  :display_name => "Wordpress download version",
  :description => "Version of Wordpress to download from the Wordpress site.",
  :default => "3.0.4"
  
attribute "wordpress/checksum",
  :display_name => "Wordpress tarball checksum",
  :description => "Checksum of the tarball for the version specified.",
  :default => "7342627f4a3dca44886c5aca6834cc88671dbd3aa2760182d2fcb9a330807"
  
attribute "wordpress/dir",
  :display_name => "Wordpress installation directory",
  :description => "Location to place wordpress files.",
  :default => "/var/www"
  
attribute "wordpress/db/database",
  :display_name => "Wordpress MySQL database",
  :description => "Wordpress will use this MySQL database to store its data.",
  :default => "wordpressdb"

attribute "wordpress/db/user",
  :display_name => "Wordpress MySQL user",
  :description => "Wordpress will connect to MySQL using this user.",
  :default => "wordpressuser"

attribute "wordpress/db/password",
  :display_name => "Wordpress MySQL password",
  :description => "Password for the Wordpress MySQL user.",
  :default => "randomly generated"

attribute "wordpress/keys/auth",
  :display_name => "Wordpress auth key",
  :description => "Wordpress auth key.",
  :default => "randomly generated"

attribute "wordpress/keys/secure_auth",
  :display_name => "Wordpress secure auth key",
  :description => "Wordpress secure auth key.",
  :default => "randomly generated"

attribute "wordpress/keys/logged_in",
  :display_name => "Wordpress logged-in key",
  :description => "Wordpress logged-in key.",
  :default => "randomly generated"

attribute "wordpress/keys/nonce",
  :display_name => "Wordpress nonce key",
  :description => "Wordpress nonce key.",
  :default => "randomly generated"
  
