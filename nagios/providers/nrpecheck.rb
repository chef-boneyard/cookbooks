
action :add do
  Chef::Log.info "Adding #{new_resource.command_name} to #{node['nagios']['nrpe']['conf_dir']}/nrpe.d/"
  template "#{node['nagios']['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
    source "nrpe_command.cfg.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :command_name => new_resource.command_name,
      :command => new_resource.command,
      :warning_condition => new_resource.warning_condition,
      :critical_condition => new_resource.critical_condition,
      :parameters => new_resource.parameters
    )
    notifies :restart, resources(:service => "nagios-nrpe-server")
  end
end

action :remove do
  if ::File.exists?("#{node['nagios']['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg")
    Chef::Log.info "Removing #{new_resource.command_name} from #{node['nagios']['nrpe']['conf_dir']}/nrpe.d/"
    file "#{node['nagios']['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
      action :delete
      notifies :restart, resources(:service => "nagios-nrpe-server")
    end
  end
end