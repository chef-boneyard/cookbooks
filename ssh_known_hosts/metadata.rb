maintainer        "Scott M. Likens"
maintainer_email  "scott@likens.us"
license           "Apache 2.0"
description       "Dyanmically generates /etc/ssh/known_hosts based on search indexes"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.1"
recipe            "ssh_known_hosts::default", "Dyanmically generates /etc/ssh/known_hosts based on search indexes"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end
