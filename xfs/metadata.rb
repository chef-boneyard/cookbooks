maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs packages for working with XFS"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.1"

recipe "xfs", "Installs packages for working with XFS"

%w{ debian ubuntu }.each do |os|
  supports os
end
