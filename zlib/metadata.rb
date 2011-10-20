maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs zlib"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe "zlib", "Installs zlib development package"

%w{ centos redhat scientific suse fedora ubuntu debian }.each do |os|
  supports os
end
