maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs sudo and configures /etc/sudoers"
version           "1.1.2"

recipe "sudo", "Installs sudo and configures /etc/sudoers"
recipe "sudo::sudoers_d", "Installs sudo and configures /etc/sudoers.d/ directory"

%w{redhat centos fedora ubuntu debian freebsd}.each do |os|
  supports os
end

attribute "authorization",
  :display_name => "Authorization",
  :description => "Hash of Authorization attributes",
  :type => "hash"

attribute "authorization/sudo",
  :display_name => "Authorization Sudoers",
  :description => "Hash of Authorization/Sudo attributes",
  :type => "hash"

attribute "authorization/sudo/users",
  :display_name => "Sudo Users",
  :description => "Users who are allowed sudo ALL",
  :type => "array",
  :default => ""

attribute "authorization/sudo/groups",
  :display_name => "Sudo Groups",
  :description => "Groups who are allowed sudo ALL",
  :type => "array",
  :default => ""

attribute "authorization/sudo/passwordless",
  :display_name => "Passwordless Sudo",
  :description => "",
  :type => "string",
  :default => "false"
