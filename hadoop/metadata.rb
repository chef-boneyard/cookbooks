maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs hadoop and sets up basic cluster per Cloudera's quick start docs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"
depends           "java"

%w{ debian ubuntu }.each do |os|
  supports os
end

