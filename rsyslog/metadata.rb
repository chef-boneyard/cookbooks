maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures rsyslog"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.2"

recipe            "rsyslog", "Installs rsyslog"
recipe            "rsyslog::client", "Sets up a client to log to a remote rsyslog server"
recipe            "rsyslog::server", "Sets up an rsyslog server"

supports          "ubuntu", ">= 8.04"
supports          "debian", ">= 5.0"

depends           "cron"

attribute "rsyslog",
  :display_name => "Rsyslog",
  :description => "Hash of Rsyslog attributes",
  :type => "hash"

attribute "rsyslog/log_dir",
  :display_name => "Rsyslog Log Directory",
  :description => "Filesystem location of logs from clients",
  :default => "/srv/rsyslog"

attribute "rsyslog/server",
  :display_name => "Rsyslog Server?",
  :description => "Is this node an rsyslog server?",
  :default => "false"

attribute "rsyslog/protocol",
  :display_name => "Rsyslog Protocol",
  :description => "Set which network protocol to use for rsyslog",
  :default => "tcp"

