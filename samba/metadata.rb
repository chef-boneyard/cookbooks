maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures samba"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.10.2"

recipe "samba::default", "Includes the samba::client recipe"
recipe "samba::client", "Installs smbclient package"
recipe "samba::server", "Installs samba server packages and configures smb.conf"

%w{ arch debian ubuntu centos fedora redhat }.each do |os|
  supports os
end
