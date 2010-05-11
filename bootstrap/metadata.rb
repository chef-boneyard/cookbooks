maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Configures RubyGems-installed Chef"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.11.2"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit couchdb rabbitmq_chef apache2 openssl zlib xml java }.each do |cb|
  depends cb
end
