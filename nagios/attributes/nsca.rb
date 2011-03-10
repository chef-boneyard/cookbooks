::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:nagios][:nsca][:decryption_method] = 3 # 3DES
default[:nagios][:nsca][:max_packet_age]    = 30
default[:nagios][:nsca][:port]    = 5667

set_unless[:nagios][:nsca][:password]    = secure_password

