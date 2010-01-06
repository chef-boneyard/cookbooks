#
# Cookbook Name:: capistrano
# Definition:: cap_setup
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

define :cap_setup, :path => nil, :owner => "root", :group => "root", :appowner => "nobody" do
  include_recipe "capistrano"

  directory params[:path] do
    owner params[:owner]
    group params[:group]
    mode 0755
  end
  
  # after chef-174 fixed, change mode to 2775
  %w{ releases shared }.each do |dir|
    directory "#{params[:path]}/#{dir}" do
      owner params[:owner]
      group params[:group]
      mode 0775
    end
  end
  
  %w{ log system }.each do |dir|
    directory "#{params[:path]}/shared/#{dir}" do
      owner params[:appowner]
      group params[:group]
      mode 0775
    end
  end  
  
end
