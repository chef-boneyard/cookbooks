maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Deploys and configures a Rails application from databag 'apps'"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4"

%w{ ruby_enterprise passenger_enterprise runit unicorn }.each do |cb|
  depends cb
end
