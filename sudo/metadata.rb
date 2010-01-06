maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures sudo"
version           "0.7"

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
