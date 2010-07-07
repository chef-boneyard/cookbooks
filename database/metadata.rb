maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Sets up the database master or slave"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.6"
recipe "database", "Empty, use one of the other recipes"
recipe "database::ebs_backup", "Set up EBS snapshot"
recipe "database::ebs_volume", "Configures an EBS volume"
recipe "database::master", "Sets up databases and users from an application data bag on the master database server"
recipe "databse::snapshot", "Perform an EBS volume snapshot to do backups"

%w{ mysql aws xfs }.each do |cb|
  depends cb
end
