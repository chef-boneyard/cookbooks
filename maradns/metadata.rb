maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures maradns"
version           "0.8"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "maradns",
  :display_name => "MaraDNS",
  :description => "Hash of MaraDNS attributes",
  :type => "hash"

attribute "maradns/recursive_acl",
  :display_name => "MaraDNS Recursive ACL",
  :description => "Sets the recursive_acl setting in mararc.erb",
  :default => ""
