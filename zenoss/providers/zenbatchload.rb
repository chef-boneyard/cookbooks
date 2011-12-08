#loads the hash into a file for zenbatchload and loads it
action :run do
  groups = new_resource.groups
  systems = new_resource.systems
  locations = new_resource.locations
  devices = new_resource.devices
  batch = ""

  #sort the groups and write them out
  groups.keys.sort!.each do |group|
    Chef::Log.debug "zenbatchload group:#{group}"
    batch += "\"/Groups/#{group}\""
    batch += " description=\"#{groups[group]['description']}\"\n"
  end
  #sort the systems and write them out
  systems.sort!.each do |system|
    Chef::Log.debug "zenbatchload system:#{system}"
    batch += "\"/Systems/#{system}\"\n"
  end
  #sort the locations and write them out
  locations.keys.sort!.each do |location|
    Chef::Log.debug "zenbatchload location:#{location}"
    batch += "\"/Locations/#{location}\""
    batch += " description=\"#{locations[location]['description']}\""
    batch += ", setAddress=\"#{locations[location]['address']}\"\n"
  end

  #sort the hash and construct the batchload file
  devices.keys.sort!.each do |dclass|
    Chef::Log.debug "zenbatchload deviceclass:#{dclass}"
    batch += "\"/Devices#{dclass}\"\n"
    #write out any settings for the device class as well?
    devices[dclass]['nodes'].sort_by {|n| n.ipaddress}.each do |device|
      #set for hybrid clouds
      if device['cloud'] and device['cloud']['public_ips']
        batch += "#{device.cloud.public_ips[0]} "
      else
        batch += "#{device.ipaddress} "
      end
      #set the ID to the ec2 public name or fqdn
      if device['ec2']
        batch += "setTitle=\"#{device['ec2']['public_hostname']}\", "
      else
        batch += "setTitle=\"#{device['fqdn']}\", "
      end
      #set the Location & Groups
      devlocation = ""
      devgroups = "setGroups=["
      device.roles.sort!.each do |role|
        if locations.member?(role)
          devlocation = "setLocation=\"/#{role}\", "
        elsif groups.member?(role)
          devgroups += "\"/#{role}\","
        end
        #ignore deviceclass roles
      end
      devgroups += "], "
      batch += devlocation
      batch += devgroups
      #set the Systems
      devsystems = "setSystems=["
      dsystems = device.expand!.recipes.sort!
      dsystems.collect! {|sys| sys.gsub('::', '/')}
      dsystems.each {|sys| devsystems += "\"/#{sys}\","}
      devsystems += "], "
      batch += devsystems
      #only use device['zenoss']['device'].current_normal for node-specific  templates, modeler_plugins and properties
      if node['zenoss'] and node['zenoss']['device'] and node['zenoss']['device'].current_normal
        if node['zenoss']['device'].current_normal['modeler_plugins']
          plugins = node['zenoss']['device'].current_normal['modeler_plugins']
          batch += "zCollectorPlugins=#{plugins}, "
        end
        if node['zenoss']['device'].current_normal['templates']
          templates = node['zenoss']['device'].current_normal['templates']
          batch += "zDeviceTemplates=#{templates}, "
        end
        if node['zenoss']['device'].current_normal['properties']
          node['zenoss']['device'].current_normal['properties'].each {|k, v| batch += "#{k}='#{v}', " }
        end
      end
      batch += "\n"
    end
  end

  #clean up any ' or -
  batch.gsub!('\'','')
  batch.gsub!('-','_')

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

