# Rakefile for OpenLDAP cookbook.
# Primarily used for generating SSL certificate(s).
# Extend with other OpenLDAP related tasks as required.

require 'tempfile'

COMPANY_NAME = "Company"
SSL_COUNTRY_NAME = "US"
SSL_STATE_NAME = "State"
SSL_LOCALITY_NAME = "City"
SSL_ORGANIZATIONAL_UNIT_NAME = "Operations"
SSL_EMAIL_ADDRESS = "operations@example.com"
CADIR = File.expand_path(File.join(File.dirname(__FILE__), "files", "default", "ssl"))

desc "Create a new self-signed SSL certificate for FQDN=foo.example.com"
task :ssl_cert do
  $expect_verbose = true
  fqdn = ENV["FQDN"]
  fqdn =~ /^(.+?)\.(.+)$/
  hostname = $1
  domain = $2
  raise "Must provide FQDN!" unless fqdn && hostname && domain
  puts "** Creating self signed SSL Certificate for #{fqdn}"
  sh("(cd #{CADIR} && openssl genrsa 2048 > #{fqdn}.key)")
  sh("(cd #{CADIR} && chmod 644 #{fqdn}.key)")
  puts "* Generating Self Signed Certificate Request"
  tf = Tempfile.new("#{fqdn}.ssl-conf")
  ssl_config = <<EOH
[ req ]
distinguished_name = req_distinguished_name
prompt = no

[ req_distinguished_name ]
C                      = #{SSL_COUNTRY_NAME}
ST                     = #{SSL_STATE_NAME}
L                      = #{SSL_LOCALITY_NAME}
O                      = #{COMPANY_NAME}
OU                     = #{SSL_ORGANIZATIONAL_UNIT_NAME}
CN                     = #{fqdn}
emailAddress           = #{SSL_EMAIL_ADDRESS}
EOH
  tf.puts(ssl_config)
  tf.close
  sh("(cd #{CADIR} && openssl req -config '#{tf.path}' -new -x509 -nodes -sha1 -days 3650 -key #{fqdn}.key > #{fqdn}.crt)")
  sh("(cd #{CADIR} && openssl x509 -noout -fingerprint -text < #{fqdn}.crt > #{fqdn}.info)")
  sh("(cd #{CADIR} && cat #{fqdn}.crt #{fqdn}.key > #{fqdn}.pem)")
  sh("(cd #{CADIR} && chmod 644 #{fqdn}.pem)")
end