maintainer       "Opscode, Inc"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Distributes a directory of custom ohai plugins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"

recipe "ohai::default", "Distributes a directory of custom ohai plugins"

attribute "ohai/plugin_path",
  :display_name => "Ohai Plugin Path",
  :description => "Distribute plugins to this path.",
  :type => "string",
  :required => "optional",
  :default => "/etc/chef/ohai_plugins"
