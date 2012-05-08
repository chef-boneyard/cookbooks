maintainer       "Michael Contento"
maintainer_email "michaelcontento@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures sloccount"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ubuntu debian}.each do |os|
  supports os
end

recipe "sloccount", "Installs sloccount package"
