maintainer       "Opscode, Inc."
maintainer_email "matt@opscode.com"
license          "Apache 2.0"
description      "Installs and configures Zenoss and registers nodes as devices"
version          "0.6.2"
depends          "apt", ">> 0.9"
depends          "openssh"
depends          "openssl"
recipe           "zenoss", "Defaults to the client recipe."
recipe           "zenoss::client", "Includes the `openssh` recipe and adds the device to the Zenoss server for monitoring."
recipe           "zenoss::server", "Installs Zenoss, handling and configuring all the dependencies while adding Device Classes, Groups, Systems and Locations.  All nodes using the `zenoss::client` recipe are added for monitoring."


#start with just the .deb, perhaps switch to stack installer and/or .rpm
%w{ debian ubuntu }.each do |os|
  supports os
end

attribute "zenoss/device/device_class",
  :display_name => "Device Class for the node.",
  :description => "Device Class for the node. May be overridden by the Role.",
  :default => "/Discovered"

attribute "zenoss/device/location",
  :display_name => "Location for the node.",
  :description => "Location for the node. May be overridden by the Role."

attribute "zenoss/device/modeler_plugins",
  :display_name => "List of modeler plugins for the node.",
  :description => "List of modeler plugins for the node. Node takes precendence over the Role if set.",
  :type => "array"

attribute "zenoss/device/properties",
  :display_name => "Hash of configuration properties for the node.",
  :description => "Hash of configuration properties for the node. Node takes precendence over the Role if set.",
  :type => "hash"

attribute "zenoss/device/templates",
  :display_name => "List of templates for the node.",
  :description => "List of templates for the node. Node takes precendence over the Role if set.",
  :type => "array"

attribute "zenoss/server/admin_password",
  :display_name => "Zenoss Admin Password",
  :description => "Randomly generated password for the admin user",
  :default => "randomly generated"

attribute "zenoss/server/version",
  :display_name => "Zenoss Version",
  :default => "3.0.3-0"

attribute "zenoss/server/zenhome",
  :display_name => "Environment variable $ZENHOME",
  :description => "$ZENHOME environment variable, directory where Zenoss is installed.",
  :default => "/usr/local/zenoss/zenoss"

attribute "zenoss/server/zenoss_pubkey",
  :display_name => "zenoss user's public key",
  :description => "zenoss user's public key on the server for use with SSH monitoring.",
  :type => "string"

attribute "zenoss/server/installed_zenpacks",
  :display_name => "Hash of ZenPacks to install.",
  :description => "Hash of ZenPacks to install. Key/value of Name/Version.",
  :type => "hash"

attribute "zenoss/server/zenpatches",
  :display_name => "zenpatch patches",
  :description => "Hash of patches to install with zenpatch. Key/value of patch number/ticket url",
  :type => "hash"

