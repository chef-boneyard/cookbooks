#
# Cookbook Name:: solr
# Definition:: solr_instance
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

define :solr_instance, :path => "/srv", :type => "master" do
  include_recipe "solr"
  
  cap_setup "#{params[:name]}" do
    path "#{params[:path]}/#{params[:name]}"
    appowner "solr"
  end

  %w{ solr solr/data }.each do |dir|
    directory "#{params[:path]}/#{params[:name]}/#{dir}" do
      owner node[:solr][:user]
      group node[:solr][:group]
      mode 0755
    end
  end

  %w{ bin conf }.each do |dir|
    directory "#{params[:path]}/#{params[:name]}/#{dir}" do
      owner "root"
      group "nogroup"
      mode 0755
    end
  end
  
  runit_service "#{params[:name]}_solr"
  
  directory "#{params[:path]}/#{params[:name]}/.ssh" do
    owner node[:solr][:user]
    group node[:solr][:group]
    mode 0700
  end

  %w{ id_rsa id_rsa.pub authorized_keys }.each do |ssh_file| 
    remote_file "#{params[:path]}/#{params[:name]}/.ssh/#{ssh_file}" do
      source ssh_file
      owner node[:solr][:user]
      group node[:solr][:group]
      mode 0600
      if params[:cookbook]
        cookbook params[:cookbook]
      else
        cookbook "solr" 
      end
    end
  end
end
