set_unless[:postfix][:mail_type]  = "client"
set_unless[:postfix][:myhostname] = fqdn
set_unless[:postfix][:mydomain]   = domain
set_unless[:postfix][:myorigin]   = "$myhostname"
set_unless[:postfix][:relayhost]  = ""
set_unless[:postfix][:mail_relay_networks] = "127.0.0.0/8"

set_unless[:postfix][:smtp_sasl_auth_enable] = "no"
set_unless[:postfix][:smtp_sasl_password_maps]    = "hash:/etc/postfix/sasl_passwd"
set_unless[:postfix][:smtp_sasl_security_options] = "noanonymous"
set_unless[:postfix][:smtp_tls_cafile] = "/etc/postfix/cacert.pem"
set_unless[:postfix][:smtp_use_tls]    = "yes"
set_unless[:postfix][:smtp_sasl_user_name] = ""
set_unless[:postfix][:smtp_sasl_passwd]    = ""
