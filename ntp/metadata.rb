maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures ntp as a client or server"
version           "0.8"

%w{ ubuntu debian redhat centos fedora }.each do |os|
  supports os
end

attribute "ntp",
  :display_name => "NTP",
  :description => "Hash of NTP attributes",
  :type => "hash"

attribute "ntp/service",
  :display_name => "NTP Service",
  :description => "Name of the NTP service",
  :default => "ntp"

attribute "ntp/is_server",
  :display_name => "NTP Is Server?",
  :description => "Set to true if this is an NTP server",
  :default => "false"

attribute "ntp/servers",
  :display_name => "NTP Servers",
  :description => "Array of servers we should talk to",
  :type => "array",
  :default => ["0.us.pool.ntp.org", "1.us.pool.ntp.org"]

