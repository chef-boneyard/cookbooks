maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures jira"
version           "0.8"
recommends        "mysql"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ runit java apache2 }.each do |cb|
  depends cb
end

attribute "jira",
  :display_name => "Jira",
  :description => "Hash of Jira attributes",
  :type => "hash"

attribute "jira/virtual_host_name",
  :display_name => "Jira Virtual Hostname",
  :description => "Apache ServerName for Jira virtual host",
  :default => "jira.domain"

attribute "jira/virtual_host_alias",
  :display_name => "Jira Virtual Hostalias",
  :description => "Apache ServerAlias for Jira virtual host",
  :default => "jira"

attribute "jira/version",
  :display_name => "Jira Version",
  :description => "Version of Jira to download and install",
  :default => "enterprise-3.13.1"

attribute "jira/install_path",
  :display_name => "Jira Install Path",
  :description => "Filesystem location for Jira",
  :default => "/srv/jira"

attribute "jira/run_user",
  :display_name => "Jira Run User",
  :description => "User the Jira instance should run as",
  :default => "www-data"

attribute "jira/database",
  :display_name => "Jira Database",
  :description => "Type of database Jira should use",
  :default => "mysql"

attribute "jira/database_host",
  :display_name => "Jira Database Host",
  :description => "Hostname of the database server",
  :default => "localhost"

attribute "jira/database_user",
  :display_name => "Jira Database User",
  :description => "Name of the database user for Jira",
  :default => "jira"

attribute "jira/database_password",
  :display_name => "Jira Database Password",
  :description => "Password for the Jira Database User",
  :default => "change_me"
