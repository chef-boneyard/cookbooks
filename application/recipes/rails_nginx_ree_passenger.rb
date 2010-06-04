#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "ruby_enterprise"

runit_service "nginx"

search(:apps) do |app|
  if (app["server_roles"] & node.run_list.roles).length > 0

    node.default[:apps][app['id']][node.app_environment][:run_migrations] = false

    ## First, install any application specific packages
    if app['packages']
      app['packages'].each do |pkg,ver|
        package pkg do
          action :install
          version ver if ver && ver.length > 0
        end
      end
    end

    ## Next, install any application specific gems
    if app['gems']
      app['gems'].each do |gem,ver|
        ree_gem gem do
          action :install
          version ver if ver && ver.length > 0
        end
      end
    end

    ## Then, configure nginx
    template "#{node[:nginx][:dir]}/sites-available/#{app['id']}.conf" do
      source "rails_nginx_passenger.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
        :app => app['id'],
        :docroot => "/srv/#{app['id']}/current/public",
        :server_name => "#{app['id']}.#{node[:domain]}",
        :server_aliases => [ node[:fqdn], app['id'] ],
        :rails_env => app['environment']
      )
    end

    nginx_site "#{app['id']}.conf" do
      notifies :restart, resources(:service => "nginx")
    end

    directory app['deploy_to'] do
      owner app['owner']
      group app['group']
      mode '0755'
      recursive true
    end

    directory "#{app['deploy_to']}/shared" do
      owner app['owner']
      group app['group']
      mode '0755'
      recursive true
    end
    
    directory "#{app['deploy_to']}/shared/log" do
      owner app['owner']
      group app['group']
      mode '0755'
      recursive true
    end

    if app.has_key?("deploy_key")
      ruby_block "write_key" do
        block do
          f = File.open("#{app['deploy_to']}/id_deploy", "w")
          f.print(app["deploy_key"])
          f.close
        end
        not_if do File.exists?("#{app['deploy_to']}/id_deploy"); end
      end

      file "#{app['deploy_to']}/id_deploy" do
        owner app['owner']
        group app['group']
        mode '0600'
      end

      template "#{app['deploy_to']}/deploy-ssh-wrapper" do
        source "deploy-ssh-wrapper.erb"
        owner app['owner']
        group app['group']
        mode "0755"
        variables app.to_hash
      end
    end

    ## Then, deploy
    deploy_revision app['id'] do
      revision app['revision'][node.app_environment]
      repository app['repository']
      user app['owner']
      group app['group']
      deploy_to app['deploy_to']
      action app['force'][node.app_environment] ? :force_deploy : :deploy
      ssh_wrapper "#{app['deploy_to']}/deploy-ssh-wrapper" if app['deploy_key']
      if app['migrate'][node.app_environment] && node[:apps][app['id']][node.app_environment][:run_migrations]
        migrate true
        migration_command "rake db:migrate"
      else
        migrate false
      end
      restart_command do
        case app["type"]
        when /nginx/
          service "nginx" do action :restart; end
        when /apache/
          service "apache" do action :restart; end
        end
      end
      symlink_before_migrate({ 
        "database.yml" => "config/database.yml",
        "memcached.yml" => "config/memcached.yml"
      })
      before_symlink do
        if app["database_master_role"]
          results = search(:node, "run_list:role\\[#{app["database_master_role"][0]}\\]", nil, 0, 1)
          rows = results[0]
          if rows.length == 1
            dbm = rows[0]
            template "#{@new_resource.shared_path}/database.yml" do
              source "database.yml.erb"
              owner app["owner"]
              group app["group"]
              mode "644"
              variables(
                :host => dbm['fqdn'],
                :databases => app['databases']
              )
            end
          else
            Chef::Log.warn("No node with role #{app["database_master_role"][0]}, database.yml not rendered!")
          end
        end
        if app["memcached_role"]
          results = search(:node, "run_list:role\\[#{app["memcached_role"][0]}\\]")
          rows = results[0]
          template "#{@new_resource.shared_path}/memcached.yml" do
            source "memcached.yml.erb"
            owner app["owner"]
            group app["group"]
            mode "644"
            variables(
              :memcached_envs => app['memcached'],
              :hosts => rows
            )
          end
        end
      end
    end
  end
end
