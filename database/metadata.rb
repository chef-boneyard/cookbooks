maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Sets up the database master or slave"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.6"

%w{ mysql aws xfs }.each do |cb|
  depends cb
end
