maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1"
recipe            "yum", "Runs 'yum update' during compile phase"

%w{ redhat centos scientific }.each do |os|
  supports os, ">= 5"
end
