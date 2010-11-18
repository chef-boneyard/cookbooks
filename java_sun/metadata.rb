maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Sun java"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.10.0"

depends 'java'

recipe "java_sun", "Installs Sun Java using preseed to accept terms"

%w{ debian ubuntu }.each do |os|
  supports os
end
