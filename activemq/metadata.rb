maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs activemq and sets it up as a runit service"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"

%w{ubuntu debian}.each do |os|
  supports os
end

%w{java runit}.each do |cb|
  depends cb
end
