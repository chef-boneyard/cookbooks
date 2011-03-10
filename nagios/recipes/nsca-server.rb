# Install the nsca daemon
#
package "nsca"

template "/etc/nsca.cfg" do
  notifies :restart, "service[nsca]"
end

service "nsca" do
  action [:enable, :start]
  running true
end

provide_service("nsca")
