maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures god and provides a define for monitoring"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"

%w{debian ubuntu}.each do |os|
  supports os
end

%w{ ruby runit }.each do |cb|
  depends cb
end
