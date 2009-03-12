postfix Mash.new unless attribute?("postfix")

postfix[:mail_type] = "client" unless postfix.has_key?(:mail_type)
postfix[:myhostname] = fqdn unless postfix.has_key?(:myhostname)
postfix[:mydomain] = domain unless postfix.has_key?(:mydomain)
postfix[:myorigin] = "$myhostname" unless postfix.has_key?(:myorigin)
postfix[:relayhost] = "" unless postfix.has_key?(:relayhost)
postfix[:mail_relay_networks] = "127.0.0.0/8" unless postfix.has_key?(:mail_relay_networks)

postfix[:smtp_sasl_auth_enable] = "no" unless postfix.has_key?(:smtp_sasl_auth_enable)

if postfix[:smtp_sasl_auth_enable] == "yes"
  postfix[:smtp_sasl_password_maps] = "hash:/etc/postfix/sasl_passwd"
  postfix[:smtp_sasl_security_options] = "noanonymous"
  postfix[:smtp_tls_cafile] = "/etc/postfix/cacert.pem"
  postfix[:smtp_use_tls] = "yes"
  postfix[:smtp_sasl_user_name] = "" unless postfix.has_key?(:smtp_sasl_user_name)
  postfix[:smtp_sasl_passwd] = "" unless postfix.has_key?(:smtp_sasl_passwd)
end
