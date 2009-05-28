# This attributes file is deprecated.
# Use mysql[:ec2_path] in server.rb instead.
mysql_ec2_path "/srv/mysql" unless attribute?("mysql_ec2_path")