# Install and setup the NSCA client

package "nsca"

service "nsca" do
  action :disable, :stop unless node.recipe? "nagios::nsca-server"
end

server = provider_for_service("nsca")
template "/etc/send_nsca.cfg" do
  variables :nsca_password => server[:nagios][:nsca][:password], :nsca_encryption_method => server[:nagios][:nsca][:decryption_method]
end
