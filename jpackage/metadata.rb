maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures jpackage"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.10.0"

depends "java"

%w{ centos redhat fedora }.each do |os|
  supports os
end

recipe "jpackage::default", "Installs and configures jpackage"