maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs DJango"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8.0"

recipe "django", "Installs django and apache2 with mod_python"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ apache2 python}.each do |cb|
  depends cb
end
