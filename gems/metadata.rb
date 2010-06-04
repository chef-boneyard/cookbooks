maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Sets up a local gem server repository or mirror"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"
recipe            "gems::server", "Sets up a local gem server repository"
recipe            "gems::mirror", "Crons an rsync of rubyforge"
depends           "apache2"
suggests          "ruby" # :-)

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "gem_server",
  :display_name => "Gem Server",
  :description => "Hash of Gem Server attributes",
  :type => "hash"

attribute "gem_server/virtual_host_name",
  :display_name => "Gem Server Virtual Hostname",
  :description => "Apache ServerName for the virtual host",
  :default => "gems.domain"
  
attribute "gem_server/virtual_host_alias",
  :display_name => "Gem Server Virtual Host Aliases",
  :description => "Array of Apache ServerAlias'es",
  :type => "array",
  :default => "gems"

attribute "gem_server/directory",
  :display_name => "Gem Server Directory",
  :description => "Filesystem location of where the gems repository is served from",
  :default => "/srv/gems"
