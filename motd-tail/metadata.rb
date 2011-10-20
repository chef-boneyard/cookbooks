maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Updates motd.tail with Chef Roles"
long_description  <<-EOH
Queries Chef for the roles assigned to the node and updates motd.tail
EOH
version           "1.0.0"
recipe            "motd", "Updates motd.tail with Chef Roles"

