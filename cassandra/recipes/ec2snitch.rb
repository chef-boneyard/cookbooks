@topo_map = search(:node, "cassandra_cluster_name:#{node[:cassandra][:cluster_name]} AND ec2:placement_availability_zone").map do |n|
  az_parts = n[:ec2][:placement_availability_zone].split('-')
  @topo_map[n['ipaddress']] = {:port => n[:cassandra][:storage_port],
                               :rack => az_parts.last[1],
                               :dc => az_parts[0..1].join('-') + "-#{az_parts.last[0]}"}
end

node.set_unless[:cassandra][:ec2_snitch_default_az] = "us-east-1a"
default_az_parts = node[:cassandra][:ec2_snitch_default_az].split('-')
@default_az = {:rack => default_az_parts.last[1], :dc => default_az_parts[0..1].join('-') + "-#{default_az_parts.last[0]}"}

template "/etc/cassandra/rack.properties" do
  variables(:topo_map => @topo_map, :default_az => @default_az)
  source "rack.properties.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "cassandra")
end