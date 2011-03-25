
#Default Config dir
default[:nagios][:nsca][:config] = "/etc/nagios/send_nsca.cfg"

if ( node[:platform] == "debian" or node[:platform] == "ubuntu" )
  default[:nagios][:nsca][:package] = "nsca"
  default[:nagios][:nsca][:config] = "/etc/send_nsca.cfg"
else
  default[:nagios][:nsca][:package] = "nagios-nsca-client"
end


default[:nagios][:nsca][:password] = "password"
default[:nagios][:nsca][:encryption_method] = 1
default[:nagios][:nsca][:port] = "5667"
