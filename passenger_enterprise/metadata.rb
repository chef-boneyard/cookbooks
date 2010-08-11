maintainer       "Opscode, Inc."
maintainer_email "ops@opscode.com"
license          "Apache 2.0"
description      "Installs and configures Passenger under Ruby Enterprise Edition with Apache"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.4.2"

recipe "passenger_enterprise", "Installs Passenger gem with Ruby Enterprise Edition"
recipe "passenger_enterprise::apache2", "Enables Apache module configuration for passenger under Ruby Enterprise Edition"
recipe "passenger_enterprise::nginx", "Installs Passenger gem w/ REE, and recompiles support into Nginx"

%w{ ruby_enterprise nginx apache2 }.each do |cb|
  depends cb
end

supports "ubuntu"
