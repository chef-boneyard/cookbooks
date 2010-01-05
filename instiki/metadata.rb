maintainer       "Opscode"
maintainer_email "joshua@opscode.com"
license          "Apache 2.0"
description      "Installs instiki, a Ruby on Rails wiki server under passenger+Apache2."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ apache2 passenger_apache2 sqlite rails }.each do |cb|
  depends cb
end
