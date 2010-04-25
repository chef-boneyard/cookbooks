maintainer       "Opscode, Inc."
maintainer_email "ops@opscode.com"
license          "Apache 2.0"
description      "Installs and configures Passenger under Ruby Enterprise Edition with Apache"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"

%w{ ruby_enterprise nginx apache2 }.each do |cb|
  depends cb
end

supports "ubuntu"
