maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Deploys and configures a variety of applications defined from databag 'apps'"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.7.0"
recipe           "application", "Loads application databags and selects recipes to use"
recipe           "application::passenger-nginx", "Installs Ruby Enterprise with Passenger under Nginx"
recipe           "application::passenger_apache2", "Sets up a deployed Rails application as a Passenger virtual host in Apache2"
recipe           "application::rails", "Deploys a Rails application specified in a data bag with the deploy_revision resource"
recipe           "application::rails_nginx_ree_passenger", "Deprecated recipe that deployed a rails application under Ruby Enterprise Edition, Passenger and Nginx"
recipe           "application::unicorn", "Sets up the deployed Rails application with Unicorn as the web server"

%w{ ruby_enterprise passenger_enterprise runit unicorn apache2 passenger_apache2}.each do |cb|
  depends cb
end
