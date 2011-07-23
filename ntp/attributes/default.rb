case platform 
when "ubuntu","debian"
  default[:ntp][:service] = "ntp"
when "redhat","centos","fedora"
  default[:ntp][:service] = "ntpd"
end

default[:ntp][:is_server] = false
default[:ntp][:servers] = ["time.nist.gov", "ntp.ubuntu.com", "0.centos.pool.ntp.org", "1.centos.pool.ntp.org", "2.centos.pool.ntp.org"]
