maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures thrift"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.2"

recipe "thrift", "Installs thrift from source"

supports "ubuntu"

%w{ build-essential boost java subversion }.each do |cb|
  depends cb
end


attribute "thrift",
  :display_name => "Thrift",
  :description => "Hash of thrift attributes",
  :type => "hash"

attribute "thrift/repo_url",
  :display_name => "Thrift subversion repository URL",
  :description => "Location of the subversion repository to pull thrift from",
  :default => "http://svn.apache.org/repos/asf/thrift"
