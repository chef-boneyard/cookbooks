maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs passenger for Apache2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.15"

%w{ packages ruby apache2 rails }.each do |cb|
  depends cb
end

%w{ redhat centos ubuntu debian }.each do |os|
  supports os
end

attribute "passenger/version",
  :display_name => "Passenger Version",
  :description => "Version of Passenger to install",
  :default => "2.2.5"

attribute "passenger/root_path",
  :display_name => "Passenger Root Path",
  :description => "Location of passenger installed gem",
  :default => "gem_dir/gems/passenger-passenger_version"

attribute "passenger/module_path",
  :display_name => "Passenger Module Path",
  :description => "Location of the compiled Apache module",
  :default => "passenger_root_path/ext/apache2/mod_passenger.so"
