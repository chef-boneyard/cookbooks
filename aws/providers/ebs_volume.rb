include Opscode::Aws::Ec2

action :create do
  raise "Cannot create a volume with a specific id (EC2 chooses volume ids)" if new_resource.volume_id
  if new_resource.snapshot_id =~ /vol/
    new_resource.snapshot_id(find_snapshot_id(new_resource.snapshot_id))
  end

  nvid = volume_id_in_node_data
  if nvid
    # volume id is registered in the node data, so check that the volume in fact exists in EC2
    vol = volume_by_id(nvid)
    exists = vol && vol[:aws_status] != "deleting"
    # TODO: determine whether this should be an error or just cause a new volume to be created. Currently erring on the side of failing loudly
    raise "Volume with id #{nvid} is registered with the node but does not exist in EC2. To clear this error, remove the ['aws']['ebs_volume']['#{new_resource.name}']['volume_id'] entry from this node's data." unless exists
  else
    # Determine if there is a volume that meets the resource's specifications and is attached to the current
    # instance in case a previous [:create, :attach] run created and attached a volume but for some reason was
    # not registered in the node data (e.g. an exception is thrown after the attach_volume request was accepted
    # by EC2, causing the node data to not be stored on the server)
    if new_resource.device && (attached_volume = currently_attached_volume(instance_id, new_resource.device))
      Chef::Log.debug("There is already a volume attached at device #{new_resource.device}")
      compatible = volume_compatible_with_resource_definition?(attached_volume)
      raise "Volume #{attached_volume[:aws_id]} attached at #{attached_volume[:aws_device]} but does not conform to this resource's specifications" unless compatible
      Chef::Log.debug("The volume matches the resource's definition, so the volume is assumed to be already created")
      node.set[:aws][:ebs_volume][new_resource.name][:volume_id] = attached_volume[:aws_id]
    else
      # If not, create volume and register its id in the node data
      nvid = create_volume(new_resource.snapshot_id, new_resource.size, new_resource.availability_zone, new_resource.timeout)
      node.set[:aws][:ebs_volume][new_resource.name][:volume_id] = nvid
      new_resource.updated = true
    end
    save_node()
  end
end

action :attach do
  vol = determine_volume

  if vol[:aws_status] == "in-use"
    if vol[:aws_instance_id] != instance_id
      raise "Volume with id #{vol[:aws_id]} exists but is attached to instance #{vol[:aws_instance_id]}"
    else
      Chef::Log.debug("Volume is already attached")
    end
  else
    # attach the volume and register its id in the node data
    attach_volume(vol[:aws_id], instance_id, new_resource.device, new_resource.timeout)
    node.set[:aws][:ebs_volume][new_resource.name][:volume_id] = vol[:aws_id]
    save_node()
    new_resource.updated = true
  end
end

action :detach do
  vol = determine_volume
  return if vol[:aws_instance_id] != instance_id
  detach_volume(vol[:aws_id], new_resource.timeout)
  new_resource.updated = true
end

action :snapshot do
  vol = determine_volume
  snapshot = ec2.create_snapshot(vol[:aws_id])
  new_resource.updated = true
  Chef::Log.info("Created snapshot of #{vol[:aws_id]} as #{snapshot[:aws_id]}")
end

action :prune do
  vol = determine_volume
  old_snapshots = Array.new
  Chef::Log.info "Checking for old snapshots"
  ec2.describe_snapshots.sort { |a,b| b[:aws_started_at] <=> a[:aws_started_at] }.each do |snapshot|
    if snapshot[:aws_volume_id] == vol[:aws_id]
      Chef::Log.info "Found old snapshot #{snapshot[:aws_id]} (#{snapshot[:aws_volume_id]}) #{snapshot[:aws_started_at]}"
      old_snapshots << snapshot
    end 
  end
  if old_snapshots.length >= new_resource.snapshots_to_keep 
    old_snapshots[new_resource.snapshots_to_keep - 1, old_snapshots.length].each do |die|
      Chef::Log.info "Deleting old snapshot #{die[:aws_id]}"
      ec2.delete_snapshot(die[:aws_id])
      new_resource.updated = true
    end
  end
end

private

def volume_id_in_node_data
  begin
    node[:aws][:ebs_volume][new_resource.name][:volume_id]
  rescue NoMethodError => e
    nil
  end
end

# Pulls the volume id from the volume_id attribute or the node data and verifies that the volume actually exists
def determine_volume
  vol_id = new_resource.volume_id || volume_id_in_node_data || currently_attached_volume(instance_id, new_resource.device)
  raise "volume_id attribute not set and no volume id is set in the node data for this resource (which is populated by action :create)" unless vol_id

  # check that volume exists
  vol = volume_by_id(vol_id)
  raise "No volume with id #{vol_id} exists" unless vol

  vol
end

# Retrieves information for a volume
def volume_by_id(volume_id)
  ec2.describe_volumes.find{|v| v[:aws_id] == volume_id}
end

# Returns the volume that's attached to the instance at the given device or nil if none matches
def currently_attached_volume(instance_id, device)
  ec2.describe_volumes.find{|v| v[:aws_instance_id] == instance_id && v[:aws_device] == device}
end

# Returns true if the given volume meets the resource's attributes
def volume_compatible_with_resource_definition?(volume)
  if new_resource.snapshot_id =~ /vol/
    new_resource.snapshot_id(find_snapshot_id(new_resource.snapshot_id))
  end
  (new_resource.size.nil? || new_resource.size == volume[:aws_size]) &&
  (new_resource.availability_zone.nil? || new_resource.availability_zone == volume[:zone]) &&
  (new_resource.snapshot_id == volume[:snapshot_id])
end

# Creates a volume according to specifications and blocks until done (or times out)
def create_volume(snapshot_id, size, availability_zone, timeout)
  availability_zone ||= instance_availability_zone
  nv = ec2.create_volume(snapshot_id, size, availability_zone)
  Chef::Log.debug("Created new volume #{nv[:aws_id]}#{snapshot_id ? " based on #{snapshot_id}" : ""}")

  # block until created
  begin
    Timeout::timeout(timeout) do
      while true
        vol = volume_by_id(nv[:aws_id])
        if vol && vol[:aws_status] != "deleting"
          if ["in-use", "available"].include?(vol[:aws_status])
            Chef::Log.info("Volume #{nv[:aws_id]} is available")
            break
          else
            Chef::Log.debug("Volume is #{vol[:aws_status]}")
          end
          sleep 3
        else
          raise "Volume #{nv[:aws_id]} no longer exists"
        end
      end
    end
  rescue Timeout::Error
    raise "Timed out waiting for volume creation after #{timeout} seconds"
  end

  nv[:aws_id]
end

# Attaches the volume and blocks until done (or times out)
def attach_volume(volume_id, instance_id, device, timeout)
  Chef::Log.debug("Attaching #{volume_id} as #{device}")
  ec2.attach_volume(volume_id, instance_id, device)

  # block until attached
  begin
    Timeout::timeout(timeout) do
      while true
        vol = volume_by_id(volume_id)
        if vol && vol[:aws_status] != "deleting"
          if vol[:aws_attachment_status] == "attached"
            if vol[:aws_instance_id] == instance_id
              Chef::Log.info("Volume #{volume_id} is attached to #{instance_id}")
              break
            else
              raise "Volume is attached to instance #{vol[:aws_instance_id]} instead of #{instance_id}"
            end
          else
            Chef::Log.debug("Volume is #{vol[:aws_status]}")
          end
          sleep 3
        else
          raise "Volume #{volume_id} no longer exists"
        end
      end
    end
  rescue Timeout::Error
    raise "Timed out waiting for volume attachment after #{timeout} seconds"
  end
end

# Detaches the volume and blocks until done (or times out)
def detach_volume(volume_id, timeout)
  Chef::Log.debug("Detaching #{volume_id}")
  vol = volume_by_id(volume_id)
  orig_instance_id = vol[:aws_instance_id]
  ec2.detach_volume(volume_id)

  # block until detached
  begin
    Timeout::timeout(timeout) do
      while true
        vol = volume_by_id(volume_id)
        if vol && vol[:aws_status] != "deleting"
          if vol[:aws_instance_id] != orig_instance_id
            Chef::Log.info("Volume detached from #{orig_instance_id}")
            break
          else
            Chef::Log.debug("Volume: #{vol.inspect}")
          end
        else
          Chef::Log.debug("Volume #{volume_id} no longer exists")
          break
        end
        sleep 3
      end
    end
  rescue Timeout::Error
    raise "Timed out waiting for volume detachment after #{timeout} seconds"
  end
end

def save_node()
  current_version = Chef::VERSION
  node_save_safe_version = '0.8'
  
  if current_version >= node_save_safe_version
    if !Chef::Config.solo
      node.save
    else
      Chef::Log.warn("Skipping node save since we are running under chef-solo.  Node attributes will not be persisted.")
    end
  else
    Chef::Log.warn("Skipping node save because saving a node in a recipe prior to version #{node_save_safe_version.to_s} isn't valid");
  end
end
