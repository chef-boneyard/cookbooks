maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs Ruby on Rails with Ruby Enterprise Edition"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.1"

recipe "rails_enterprise", "Installs Ruby on Rails with Ruby Enterprise Edition"

%w{ ruby_enterprise }.each do |cb|
  depends cb
end

supports "ubuntu"

attribute "rails_enterprise",
  :display_name => "Rails",
  :description => "Hash of Rails attributes",
  :type => "hash"

attribute "rails_enterprise/version",
  :display_name => "Rails Version",
  :description => "Specify the version of Rails to install",
  :default => "false"

attribute "rails_enterprise/environment",
  :display_name => "Rails Environment",
  :description => "Specify the environment to use for Rails",
  :default => "production"

attribute "rails_enterprise/max_pool_size",
  :display_name => "Rails Max Pool Size",
  :description => "Specify the MaxPoolSize in the Apache vhost",
  :default => "4"
