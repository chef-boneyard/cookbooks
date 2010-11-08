maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures ruby-enterprise"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2.4"

recipe "ruby_enterprise", "Installs Ruby Enterprise Edition"

depends "build-essential"
%w{redhat centos fedora ubuntu}.each do |os|
  supports os
end

attribute "ruby_enterprise/install_path",
  :display_name => "Ruby Enterprise Installation Path",
  :description => "Specify the base location where REE will be installed",
  :default => "/opt/ruby-enterprise"

attribute "ruby_enterprise/ruby_bin",
  :display_name => "Ruby Enterprise Binary",
  :description => "Location of the ruby executable for REE",
  :default => "/opt/ruby-enterprise/bin/ruby"

attribute "ruby_enterprise/gems_dir",
  :display_name => "Ruby Enterprise Gem Directory",
  :description => "Location where Rubygems are installed for REE",
  :default => "ruby_enterprise_install_path/lib/ruby/gems/1.8"

attribute "ruby_enterprise/version",
  :display_name => "Ruby Enterprise version",
  :description => "Specify the version of REE to install",
  :default => "1.8.7-2010.02"

attribute "ruby_enterprise/url",
  :display_name => "Ruby Enterprise Source URL",
  :description => "Specify the URL for fetching the REE source to compile",
  :default => "http://rubyforge.org/frs/download.php/71096/ruby-enterprise-ruby_enterprise_version"
