maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures postfix for client or outbound relayhost, or to do SASL auth"
version           "0.8"
recipe            "postfix::sasl_auth", "Set up postfix to auth to a server with sasl"

%w{ubuntu debian}.each do |os|
  supports os
end

attribute "postfix",
  :display_name => "Postfix",
  :description => "Hash of Postfix attributes",
  :type => "hash"

attribute "postfix/mail_type",
  :display_name => "Postfix Mail Type",
  :description => "Is this node a client or server?",
  :default => "client"

attribute "postfix/myhostname",
  :display_name => "Postfix Myhostname",
  :description => "Sets the myhostname value in main.cf",
  :default => "fqdn"

attribute "postfix/mydomain",
  :display_name => "Postfix Mydomain",
  :description => "Sets the mydomain value in main.cf",
  :default => "domain"

attribute "postfix/myorigin",
  :display_name => "Postfix Myorigin",
  :description => "Sets the myorigin value in main.cf",
  :default => "$myhostname"

attribute "postfix/relayhost",
  :display_name => "Postfix Relayhost",
  :description => "Sets the relayhost value in main.cf",
  :default => ""

attribute "postfix/mail_relay_networks",
  :display_name => "Postfix Mail Relay Networks",
  :description => "Sets the mynetworks value in main.cf",
  :default => "127.0.0.0/8"

attribute "postfix/smtp_sasl_auth_enable",
  :display_name => "Postfix SMTP SASL Auth Enable",
  :description => "Enable SMTP SASL Authentication",
  :default => "no"

attribute "postfix/smtp_sasl_password_maps",
  :display_name => "Postfix SMTP SASL Password Maps",
  :description => "hashmap of SASL passwords",
  :default => "hash:/etc/postfix/sasl_passwd"

attribute "postfix/smtp_sasl_security_options",
  :display_name => "Postfix SMTP SASL Security Options",
  :description => "Sets the value of smtp_sasl_security_options in main.cf",
  :default => "noanonymous"

attribute "postfix/smtp_tls_cafile",
  :display_name => "Postfix SMTP TLS CA File",
  :description => "CA certificate file for SMTP over TLS",
  :default => "/etc/postfix/cacert.pem"

attribute "postfix/smtp_use_tls",
  :display_name => "Postfix SMTP Use TLS?",
  :description => "Whether SMTP SASL Auth should use TLS encryption",
  :default => "yes"

attribute "postfix/smtp_sasl_user_name",
  :display_name => "Postfix SMTP SASL Username",
  :description => "User to auth SMTP via SASL",
  :default => ""

attribute "postfix/smtp_sasl_passwd",
  :display_name => "Postfix SMTP SASL Password",
  :description => "Password for smtp_sasl_user_name",
  :default => ""

