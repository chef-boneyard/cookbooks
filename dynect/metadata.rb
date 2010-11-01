maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "LWRP for managing DNS records with Dynect's REST API"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.2"
recipe "dynect", "Installs the dynect_rest RubyGem"
recipe "dynect::ec2", "Dynamically configures Dyn resource records for EC2 nodes based on instance ID and prepopulated attributes on the node"
recipe "dynect::a_record", "Example resource usage to configure an A record"
