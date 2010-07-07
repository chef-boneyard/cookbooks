maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures thrift"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.1"

recipe "thrift", "Installs thrift from source"

supports "ubuntu"

%w{ build-essential boost java subversion }.each do |cb|
  depends cb
end
