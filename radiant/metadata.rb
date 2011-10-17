maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs radiant from Git repository"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.1"

recipe "radiant", "Installs Radiant CMS"
recipe "radiant::db_bootstrap", "Bootstrap the Radiant database, used with application cookbook (destructive)"

%w{ git sqlite apache2 mysql passenger_apache2 }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end
