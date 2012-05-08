maintainer       "www.agileweboperations.com"
maintainer_email "mm@agileweboperations.com"
license          "All rights reserved"
description      "Installs RVM (Ruby Version Manager) and REE (Ruby Enterprise Edition) and makes REE the default ruby on the box"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends "build-essential"
