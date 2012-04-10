include Opscode::Aws::Ec2

action :register do
  elb.register_instances_with_load_balancer(new_resource.name, instance_id)
  new_resource.updated_by_last_action(true)
  Chef::Log.info("Added node to ELB #{new_resource.name}")
end

action :deregister do
  Chef::Log.info("Removing node from ELB #{new_resource.name}")
  elb.deregister_instances_with_load_balancer(new_resource.name, instance_id)
  new_resource.updated_by_last_action(true)
end

private

def elb
  region = instance_availability_zone
  region = region[0, region.length-1]
  @@elb ||= RightAws::ElbInterface.new(new_resource.aws_access_key, new_resource.aws_secret_access_key, { :logger => Chef::Log, :region => region })
end

