#
# Author:: Jake Vanderdray <jvanderdray@customink.com>
# Cookbook Name:: nagios
# Provider:: nrpecheck
#
# Copyright 2011, CustomInk LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

action :add do
  Chef::Log.info "Adding #{new_resource.command_name} to #{node['nagios']['nrpe']['conf_dir']}/nrpe.d/"
  command = new_resource.command || "#{node['nagios']['plugin_dir']}/#{new_resource.command_name}"
  template "#{node['nagios']['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
    source "nrpe_command.cfg.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :command_name => new_resource.command_name,
      :command => command,
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
      notifies :restart, "service[nagios-nrpe-server]"
    end
  end
end
