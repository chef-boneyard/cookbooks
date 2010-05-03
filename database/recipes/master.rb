#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: database
# Recipe:: master
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
include_recipe "aws"
begin
  aws = Chef::DataBagItem.load(:aws, :main)
  Chef::Log.info("Loaded AWS information from DataBagItem aws[#{aws['id']}]")
rescue
  Chef::Log.fatal("Could not find the 'main' item in the 'aws' data bag")
  raise
end

include_recipe "mysql::server"
Gem.clear_paths
require 'mysql'

db_info = Hash.new
root_pw = String.new

databases_to_backup = []

search(:apps) do |app|
  (app['database_master_role'] & node.run_list.roles).each do |dbm_role|
    app['databases'].each do |env,db|
      if env =~ /#{node[:app_environment]}/
        databases_to_backup << db['database']
        root_pw = app["mysql_root_password"][node[:app_environment]]
        execute "create-database-#{db['database']}" do
          command "/usr/bin/mysqladmin -u root -p#{root_pw} create #{db['database']}"
          not_if do
            m = Mysql.new("localhost", "root", root_pw)
            m.list_dbs.include?(db['database'])
          end
        end
      end
    end
  end
end

if node[:ec2]
  # Install s3cmd so we can do restores.
  begin
    aws = Chef::DataBagItem.load(:aws, :main)
  rescue
    Chef::Log.fatal("Could not find the 'main' item in the 'aws' data bag.")
    return
  end

  package "s3cmd"

  template "/root/.s3cfg" do
    source "s3cfg.erb"
    owner "root"
    group "root"
    mode "0600"
    variables :aws => aws
  end
end

ruby_block "store_#{node[:app_environment]}_status" do
  block do
    master_status = Hash.new
    m = Mysql.new("localhost", "root", root_pw)
    m.query("show master status") do |row|
      row.each_hash do |h|
        master_status['File'] = h['File']
        master_status['Position'] = h['Position']
      end
    end
    item = {
      "id" => "#{node[:app_environment]}_replication_status",
      "master_file" => master_status['File'],
      "master_position" => master_status['Position']
    }
    Chef::Log.info "Storing database master replication status: #{item.inspect}"
    databag_item = Chef::DataBagItem.new
    databag_item.data_bag("dbmaster")
    databag_item.raw_data = item
    databag_item.save
    Chef::Log.info("Created #{item['id']} in #{databag_item.data_bag}")
  end
end
