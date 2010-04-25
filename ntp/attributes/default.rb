case platform 
when "ubuntu","debian"
  set_unless[:ntp][:service] = "ntp"
when "redhat","centos","fedora"
  set_unless[:ntp][:service] = "ntpd"
end

set_unless[:ntp][:is_server] = false
set_unless[:ntp][:servers]   = ["0.us.pool.ntp.org", "1.us.pool.ntp.org"]
