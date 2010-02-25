maintainer       "Barry Steinglass"
maintainer_email "barry@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures wordpress"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"
depends          "php"
depends          "apache2"
depends          "mysql"
depends          "openssl"

%w{ debian ubuntu }.each do |os|
  supports os
end

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
  
