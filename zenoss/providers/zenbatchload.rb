#loads the hash into a file for zenbatchload and loads it
action :run do
  devices = new_resource.devices
  locations = new_resource.locations
  groups = new_resource.groups
  batch = ""
  Chef::Log.debug "zenbatchload devices:#{devices}"
  Chef::Log.debug "zenbatchload locations:#{locations}"
  Chef::Log.debug "zenbatchload groups:#{groups}"
  #sort the hash and construct the batchload file
  devices.keys.sort!.each do |dclass|
    batch += "#{dclass}\n"
    devices[dclass].sort_by {|n| n.ipaddress}.each do |device|
      #set for hybrid clouds
      if device.attribute["cloud"] and device.attribute["cloud"]["public_ips"]
        batch += "#{device.cloud.public_ips[0]} "
      else
        batch += "#{device.ipaddress} "
      end
      #set the ID to the ec2 public name or fqdn
      if device.attribute["ec2"]
        batch += "setTitle='#{device["ec2"]["public_hostname"]}', "
      else
        batch += "setTitle='#{device["fqdn"]}', "
      end
      #set the Location & Groups
      devlocation = ""
      devgroups = "setGroups=[["
      device.roles.each do |role|
        if locations.member?(role)
          devlocation = "setLocation='#{role}', "
        elsif groups.member?(role)
          devgroups += "'#{role}',"
        end
        #ignore deviceclass roles
      end
      devgroups += "]], "
      batch += "#{devlocation}#{devgroups}"
      #set the Systems 
      devsystems = "setSystems=[["
      systems = device.expand!.recipes
      systems.collect! {|sys| sys.gsub('::', '/')}
      systems.each {|sys| devsystems += "'#{sys}',"}
      devsystems += "]], "
      batch += "#{devsystems}"
      #only use device.attribute["zenoss"]["device"].current_normal for node-specific  templates, modeler_plugins and properties
      if node.attribute["zenoss"] and node.attribute["zenoss"]["device"] and node.attribute["zenoss"]["device"].current_normal
        if node.attribute["zenoss"]["device"].current_normal["modeler_plugins"]
          plugins = node.attribute["zenoss"]["device"].current_normal["modeler_plugins"]
          batch += "zCollectorPlugins=#{plugins}, "
        end
        if node.attribute["zenoss"]["device"].current_normal["templates"]
          templates = node.attribute["zenoss"]["device"].current_normal["templates"]
          batch += "zDeviceTemplates=#{templates}, "
        end
        if node.attribute["zenoss"]["device"].current_normal["properties"]
          node.attribute["zenoss"]["device"].current_normal["properties"].each {|k, v| batch += "#{k}='#{v}', " }
        end
      end
      batch += "\n"
    end
  end
  Chef::Log.debug batch
  #write the content to a temp file
  file "/tmp/chefzenbatch.batch" do
    owner "zenoss"
    mode "0600"
    content batch
    action :create
  end
  #run the command as the zenoss user
  execute "zenbatchload" do
    user "zenoss"
    environment ({
                   'LD_LIBRARY_PATH' => "#{node[:zenoss][:server][:zenhome]}/lib",
                   'PYTHONPATH' => "#{node[:zenoss][:server][:zenhome]}/lib/python",
                   'ZENHOME' => node[:zenoss][:server][:zenhome]
                 })
    command "#{node[:zenoss][:server][:zenhome]}/bin/zenbatchload /tmp/chefzenbatch.batch"
    action :run
  end
end

