ntp Mash.new unless attribute?("ntp")

case platform 
when "ubuntu","debian"
  ntp[:service] = "ntp"
when "redhat","centos","fedora"
  ntp[:service] = "ntpd"
end unless ntp.has_key?(:service)

ntp[:is_server] = false unless ntp.has_key?(:is_server)
ntp[:servers] = ["0.us.pool.ntp.org", "1.us.pool.ntp.org"] unless ntp.has_key?(:servers)
