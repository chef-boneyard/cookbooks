maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs gecode"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.0"

%w{ debian ubuntu redhat centos fedora mac_os_x }.each do |os|
  supports os
end

%w{ build-essential apt }.each do |cb|
  depends cb
end
