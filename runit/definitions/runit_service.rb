#
# Cookbook Name:: runit
# Definition:: runit_service
#
# Copyright 2008-2009, Opscode, Inc.
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
#

define :runit_service, :directory => nil, :only_if => false, :finish_script => false, :control => [], :run_restart => true, :options => Hash.new do
  include_recipe "runit"

  params[:directory] ||= node[:runit][:sv_dir]

  sv_dir_name = "#{params[:directory]}/#{params[:name]}"

  directory sv_dir_name do
    mode 0755
    action :create
  end

  directory "#{sv_dir_name}/log" do
    mode 0755
    action :create
  end

  directory "#{sv_dir_name}/log/main" do
    mode 0755
    action :create
  end

  params[:template_name] ||= params[:name]
  template "#{sv_dir_name}/run" do
    mode 0755
    source "sv-#{params[:template_name]}-run.erb"
    cookbook params[:cookbook] if params[:cookbook]
    if params[:options].respond_to?(:has_key?)
      variables :options => params[:options]
    end
  end

  template "#{sv_dir_name}/log/run" do
    mode 0755
    source "sv-#{params[:template_name]}-log-run.erb"
    cookbook params[:cookbook] if params[:cookbook]
    if params[:options].respond_to?(:has_key?)
      variables :options => params[:options]
    end
  end

  if params[:finish_script]
    template "#{sv_dir_name}/finish" do
      mode 0755
      source "sv-#{params[:template_name]}-finish.erb"
      cookbook params[:cookbook] if params[:cookbook]
      if params[:options].respond_to?(:has_key?)
        variables :options => params[:options]
      end
    end
  end

  unless params[:control].empty?
    directory "#{sv_dir_name}/control" do
      mode 0755
      action :create
    end

    params[:control].each do |signal|
      template "#{sv_dir_name}/control/#{signal}" do
        mode 0755
        source "sv-#{params[:template_name]}-control-#{signal}.erb"
        cookbook params[:cookbook] if params[:cookbook]
        if params[:options].respond_to?(:has_key?)
          variables :options => params[:options]
        end
      end
    end
  end

  link "/etc/init.d/#{params[:name]}" do
    to node[:runit][:sv_bin]
  end

  link "#{node[:runit][:service_dir]}/#{params[:name]}" do 
    to "#{sv_dir_name}"
  end

  ruby_block "supervise_#{params[:name]}_sleep" do
    block do
      Chef::Log.debug("Waiting until named pipe #{sv_dir_name}/supervise/ok exists.")
      (1..10).each {|i| sleep 1 unless ::FileTest.pipe?("#{sv_dir_name}/supervise/ok") }
    end
    not_if { FileTest.pipe?("#{sv_dir_name}/supervise/ok") }
  end

  service params[:name] do
    provider Chef::Provider::Service::Init
    supports :restart => true, :status => true
    start_command "#{node[:runit][:sv_bin]} start #{params[:name]}"
    stop_command "#{node[:runit][:sv_bin]} stop #{params[:name]}"
    restart_command "#{node[:runit][:sv_bin]} restart #{params[:name]}"
    status_command "#{node[:runit][:sv_bin]} status #{params[:name]}"
    if params[:run_restart]
      subscribes :restart, resources(:template => "#{sv_dir_name}/run"), :delayed
    end
    action :nothing
  end

end
