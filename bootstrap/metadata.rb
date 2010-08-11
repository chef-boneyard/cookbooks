maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Configures RubyGems-installed Chef"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.11.4"
recipe "bootstrap", "This cookbook is deprecated in favor of using the chef cookbook and its bootstrap recipes"
recipe "bootstrap::client", "This cookbook is deprecated in favor of using the chef cookbook and its bootstrap recipes"
recipe "bootstrap::server", "This cookbook is deprecated in favor of using the chef cookbook and its bootstrap recipes"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit couchdb rabbitmq_chef apache2 openssl zlib xml java }.each do |cb|
  depends cb
end
