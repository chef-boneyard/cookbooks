maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs passenger for Apache2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.4"

recipe "passenger_apache2", "Installs Passenger as an Apache module"
recipe "passenger_apache2::mod_rails", "Enables Apache module configuration for passenger module"

depends "apache2", ">= 1.0.4"
depends "build-essential"

%w{ redhat centos ubuntu debian arch }.each do |os|
  supports os
end
