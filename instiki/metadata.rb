maintainer       "Opscode"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs instiki, a Ruby on Rails wiki server under passenger+Apache2."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2.1"

recipe "instiki", "Installs instiki and sets up an apache vhost under passenger."
%w{ apache2 passenger_apache2 sqlite rails }.each do |cb|
  depends cb
end
