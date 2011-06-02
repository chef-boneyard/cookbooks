#runs a command via zendmd
action :run do
  Chef::Log.info "zenoss_zendmd:#{new_resource.name}"
  Chef::Log.debug "#{new_resource.command}"
  #write the content to a temp file
  dmdscript = "#{rand(1000000)}.dmd"
  file "/tmp/#{dmdscript}" do
    backup false
    owner "zenoss"
    mode "0600"
    content new_resource.command
    action :create
  end
  #run the command as the zenoss user
  execute "zendmd" do
    user "zenoss"
    cwd "/tmp"
    environment ({
                   'LD_LIBRARY_PATH' => "#{node[:zenoss][:server][:zenhome]}/lib",
                   'PYTHONPATH' => "#{node[:zenoss][:server][:zenhome]}/lib/python",
                   'ZENHOME' => node[:zenoss][:server][:zenhome]
                 })
    command "#{node[:zenoss][:server][:zenhome]}/bin/zendmd --commit --script=#{dmdscript}"
    action :run
  end
  #remove the temp file
  file "/tmp/#{dmdscript}" do
    action :delete
  end
end

#based on Device Class roles
action :deviceclass do
  dclass = new_resource.name
  command = "dmd.Devices.createOrganizer('#{dclass}')\n"
  dmdpath = "dmd.Devices"+dclass.gsub('/', '.')
  command += "#{dmdpath}.description='#{new_resource.description}'\n"
  plugins = new_resource.modeler_plugins
  if plugins and (plugins.length > 0)
    pluginscommand = "#{dmdpath}.setZenProperty('zCollectorPlugins', ("
    plugins.each {|p| pluginscommand += "'#{p}',"}
    pluginscommand += "))\n"
    command += pluginscommand
  end
  templates = new_resource.templates
  if templates and (templates.length > 0)
    templatescommand = "#{dmdpath}.setZenProperty('zDeviceTemplates', ["
    templates.each {|t| templatescommand += "'#{t}',"}
    templatescommand += "])\n"
    command += templatescommand
  end
  properties = new_resource.properties
  if properties
    properties.each {|p, v| command += "#{dmdpath}.setZenProperty('#{p}','#{v}')\n"}
  end
  zenoss_zendmd "Setting Device Class #{dclass}" do
    command command
    action :run
  end
end

#based on Location roles
action :location do
  location = new_resource.location
  command = "dmd.Locations.createOrganizer('#{location}')\n"
  dmdpath = "dmd.Locations" + location.gsub('/', '.')
  command += "#{dmdpath}.name='#{new_resource.name}'\n"
  command += "#{dmdpath}.description='#{new_resource.description}'\n"
  command += "#{dmdpath}.address='#{new_resource.address}'\n"
  zenoss_zendmd "Setting Location #{location}" do
    command command
    action :run
  end
end

#all non Device Class or Location roles
action :group do
  name = new_resource.name
  command = "dmd.Groups.createOrganizer('#{name}')\n"
  command += "dmd.Groups.#{name}.description='#{new_resource.description}'\n"
  zenoss_zendmd "Setting Group #{name}" do
    command command
    action :run
  end
end

#based on recipes used by nodes
action :system do
  name = new_resource.name
  command = "dmd.Systems.createOrganizer('#{name}')\n"
  zenoss_zendmd "Setting System #{name}" do
    command command
    action :run
  end
end

action :users do
  command = ""
  new_resource.users.each do |user|
    userid = user.id
    if user.has_key?("zenoss")
      password = user['zenoss']['password']
      pager = user['zenoss']['pager']
      email = user['zenoss']['email']
      roles = user['zenoss']['roles']
      user_groups = user['zenoss']['user_groups']
    end
    command += "dmd.ZenUsers.manage_addUser('#{userid}'"
    command += ", '#{password}'" if password
    command += ", email='#{email}'" if email
    command += ", pager='#{pager}'" if pager
    if roles and (roles.length > 0)
      command += ", roles=("
      roles.each {|r| command += "'#{r}',"}
      command += ")"
    end
    command += ")\n"
    if user_groups and (user_groups.length > 0)
      user_groups.each {|g| command += "dmd.ZenUsers.manage_addGroup('#{g}')\n"}
      command += "dmd.ZenUsers.manage_addUsersToGroups('#{userid}', ("
      user_groups.each {|g| command += "'#{g}',"}
      command += "))\n"
    end
  end
  zenoss_zendmd "Creating users and user groups" do
    command command
    action :run
  end
end
