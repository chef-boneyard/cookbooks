include Opscode::Aws::Ec2

action :associate do
  addr = address(new_resource.ip)

  if addr.nil?
    raise "Elastic IP #{new_resource.ip} does not exist"
  elsif addr[:instance_id] == instance_id
    Chef::Log.debug("Elastic IP #{new_resource.ip} is already attached to the instance")
  else
    attach(new_resource.ip, new_resource.timeout)
    new_resource.updated_by_last_action(true)
    Chef::Log.info("Attaching Elastic IP #{new_resource.ip} to the instance")
  end
end

action :disassociate do
  addr = address(new_resource.ip)

  if addr.nil?
    Chef::Log.debug("Elastic IP #{new_resource.ip} does not exist, so there is nothing to detach")
  elsif addr[:instance_id] != instance_id
    Chef::Log.debug("Elastic IP #{new_resource.ip} is already detached from the instance")
  else
    Chef::Log.info("Detaching Elastic IP #{new_resource.ip} from the instance")
    detach(new_resource.ip, new_resource.timeout)
    new_resource.updated_by_last_action(true)
  end
end

private

def address(ip)
  ec2.describe_addresses.find{|a| a[:public_ip] == ip}
end

def attach(ip, timeout)
  ec2.associate_address(instance_id, ip)

  # block until attached
  begin
    Timeout::timeout(timeout) do
      while true
        addr = address(ip)
        if addr.nil?
          raise "Elastic IP has been deleted while waiting for attachment"
        elsif addr[:instance_id] == instance_id
          Chef::Log.debug("Elastic IP is attached to this instance")
          break
        else
          Chef::Log.debug("Elastic IP is currently attached to #{addr[:instance_id]}")
        end
        sleep 3
      end
    end
  rescue Timeout::Error
    raise "Timed out waiting for attachment after #{timeout} seconds"
  end
end

def detach(ip, timeout)
  ec2.disassociate_address(ip)

  # block until detached
  begin
    Timeout::timeout(timeout) do
      while true
        addr = address(ip)
        if addr.nil?
          Chef::Log.debug("Elastic IP has been deleted while waiting for detachment")
        elsif addr[:instance_id] != instance_id
          Chef::Log.debug("Elastic IP is detached from this instance")
          break
        else
          Chef::Log.debug("Elastic IP is still attached")
        end
        sleep 3
      end
    end
  rescue Timeout::Error
    raise "Timed out waiting for detachment after #{timeout} seconds"
  end
end
