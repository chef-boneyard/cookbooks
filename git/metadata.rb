maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs git and/or sets up a Git server daemon"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
recipe            "git::server", "Sets up a runit_service for git daemon"

%w{ apache2 runit }.each do |cb|
  depends cb
end
