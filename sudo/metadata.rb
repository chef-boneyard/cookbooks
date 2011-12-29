maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs sudo and configures /etc/sudoers"
version           "1.0.1"

recipe "sudo", "Installs sudo and configures /etc/sudoers"

%w{redhat centos fedora ubuntu debian freebsd}.each do |os|
  supports os
end

attribute "authorization",
  :display_name => "Authorization",
  :description => "Hash of Authorization attributes",
  :type => "hash"

attribute "authorization/sudoers",
  :display_name => "Authorization Sudoers",
  :description => "Hash of Authorization/Sudoers attributes",
  :type => "hash"

attribute "authorization/sudoers/users",
  :display_name => "Sudo Users",
  :description => "Users who are allowed sudo ALL",
  :type => "array",
  :default => ""

attribute "authorization/sudoers/groups",
  :display_name => "Sudo Groups",
  :description => "Groups who are allowed sudo ALL",
  :type => "array",
  :default => ""

attribute "authorization/sudoers/passwordless",
  :display_name => "Passwordless Sudo",
  :description => "",
  :type => "string",
  :default => "false"

attribute "users",
  :display_name => "Users with sudo privileges",
  :description => "Users to pull from sudoers data bag",
  :type => "array",
  :default => ""

attribute "testing",
  :display_name => "Testing flag",
  :description => "Set to true to write a test file, rather than clobber /etc/sudoers",
  :default => "false"
