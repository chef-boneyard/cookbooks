maintainer       "Opscode, Inc."
maintainer_email "ops@opscode.com"
license          "Apache 2.0"
description      "Installs Ruby on Rails with Ruby Enterprise Edition"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.1"

recipe "rails_enterprise", "Installs Ruby on Rails with Ruby Enterprise Edition"
%w{ ruby_enterprise }.each do |cb|
  depends cb
end

supports "ubuntu"
