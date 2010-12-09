maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures ruby-enterprise"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2.4"

recipe "ruby_enterprise", "Installs Ruby Enterprise Edition"

depends "build-essential"
%w{redhat centos fedora ubuntu}.each do |os|
  supports os
end
