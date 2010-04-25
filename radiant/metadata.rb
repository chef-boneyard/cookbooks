maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs radiant from Git repository"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.10"

%w{ git sqlite rails apache2 mysql passenger_apache2 apache2 }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "radiant/branch",
  :display_name => "Radiant Branch",
  :description => "Branch from Git to use",
  :default => "HEAD"

attribute "radiant/migrate",
  :display_name => "Radiant Migrate",
  :description => "Whether to do a migration",
  :default => "false"

attribute "radiant/migrate_command",
  :display_name => "Radiant Migrate Command",
  :description => "Command to perform migration",
  :default => "rake db:migrate"

attribute "radiant/environment",
  :display_name => "Radiant Environment",
  :description => "Rails environment to use",
  :default => "production"

attribute "radiant/revision",
  :display_name => "Radiant Revision",
  :description => "Revision to use from Git",
  :default => "HEAD"

attribute "radiant/action",
  :display_name => "Radiant Action",
  :description => "Whether to deploy the application or not",
  :default => "nothing"
