begin
  default[:ec2][:status] = "running" if node.cloud.provider == "ec2"
rescue
end
