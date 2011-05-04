#
# Cookbook Name:: application
# Recipe:: wsgi
#
# Copyright 2011, Opscode, Inc.
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

app = node.run_state[:current_app]

include_recipe "python"

###
# You really most likely don't want to run this recipe from here - let the
# default application recipe work it's mojo for you.
###

node.default[:apps][app['id']][node.app_environment][:run_migrations] = false

# the Django split-settings file name varies from project to project...+1 for standardization
local_settings_full_path = app['local_settings_file'] || 'settings_local.py'
local_settings_file_name = local_settings_full_path.split(/[\\\/]/).last

## Create required directories

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

## Create a virtualenv for the app
ve = python_virtualenv app['id'] do
  path "#{app['deploy_to']}/shared/env"
  action :create
end

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
if app['pips']
  app['pips'].each do |pip,ver|
    python_pip pip do
      version ver if ver && ver.length > 0
      virtualenv ve.path
      action :install
    end
  end
end

if app.has_key?("deploy_key")
  ruby_block "write_key" do
    block do
      f = ::File.open("#{app['deploy_to']}/id_deploy", "w")
      f.print(app["deploy_key"])
      f.close
    end
    not_if do ::File.exists?("#{app['deploy_to']}/id_deploy"); end
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

if app["database_master_role"]
  dbm = nil
  # If we are the database master
  if node.run_list.roles.include?(app["database_master_role"][0])
    dbm = node
  else
  # Find the database master
    results = search(:node, "run_list:role\\[#{app["database_master_role"][0]}\\] AND app_environment:#{node[:app_environment]}", nil, 0, 1)
    rows = results[0]
    if rows.length == 1
      dbm = rows[0]
    end
  end
  
  # we need the django version to render the correct type of settings.py file
  django_version = 1.2
  if app['pips'].has_key?('django') && !app['pips']['django'].strip.empty?
    django_version = app['pips']['django'].to_f
  end

  # Assuming we have one...
  if dbm
    # local_settings.py
    template "#{app['deploy_to']}/shared/#{local_settings_file_name}" do
      source "settings.py.erb"
      owner app["owner"]
      group app["group"]
      mode "644"
      variables(
        :host => dbm['fqdn'],
        :database => app['databases'][node.app_environment],
        :django_version => django_version
      )
    end
  else
    Chef::Log.warn("No node with role #{app["database_master_role"][0]}, #{local_settings_file_name} not rendered!")
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
  shallow_clone true
  purge_before_symlink([])
  create_dirs_before_symlink([])
  symlinks({})
  before_migrate do
    requirements_file = nil
    # look for requirements.txt files in common locations
    if ::File.exists?(::File.join(release_path, "requirements", "#{node[:app_environment]}.txt"))
      requirements_file = ::File.join(release_path, "requirements", "#{node[:app_environment]}.txt")
    elsif ::File.exists?(::File.join(release_path, "requirements.txt"))
      requirements_file = ::File.join(release_path, "requirements.txt")
    end
    
    if requirements_file
      Chef::Log.info("Installing pips using requirements file: #{requirements_file}")
      execute "pip install -E #{ve.path} -r #{requirements_file}" do
        ignore_failure true
        cwd release_path
      end
    end
  end

  symlink_before_migrate({
    local_settings_file_name => local_settings_full_path
  })

  if app['migrate'][node.app_environment] && node[:apps][app['id']][node.app_environment][:run_migrations]
    migrate true
    migration_command app['migration_command'] || "#{::File.join(ve.path, "bin", "python")} manage.py migrate"
  else
    migrate false
  end
  before_symlink do
    ruby_block "remove_run_migrations" do
      block do
        if node.role?("#{app['id']}_run_migrations")
          Chef::Log.info("Migrations were run, removing role[#{app['id']}_run_migrations]")
          node.run_list.remove("role[#{app['id']}_run_migrations]")
        end
      end
    end
  end
end
