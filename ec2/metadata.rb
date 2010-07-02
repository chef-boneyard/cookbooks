maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Manage EC2 metadata as attributes"
version           "0.9"

%w{ ubuntu debian}.each do |os|
  supports os
end

recipe "default", "Default ec2 recipe does not configure anything."

attribute "ec2_metadata",
  :display_name => "EC2 Metadata",
  :description => "Retrieve EC2 instance metadata"
