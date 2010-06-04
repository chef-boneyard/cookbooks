maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Deploys and configures a Rails application from databag 'apps'"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5"

%w{ ruby_enterprise passenger_enterprise runit unicorn apache2 passenger_apache2}.each do |cb|
  depends cb
end
