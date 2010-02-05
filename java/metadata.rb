maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs java"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.9"

%w{ debian ubuntu }.each do |os|
  supports os
end
