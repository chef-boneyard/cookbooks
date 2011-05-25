#
# Cookbook Name:: passenger_apache2
# Recipe:: default
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
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

include_recipe "packages"
include_recipe "ruby"
include_recipe "apache2"

if platform?("centos","redhat")
  if dist_only?
    # just the gem, we'll install the apache module within apache2
    package "rubygem-passenger"
    return
  else
    package "httpd-devel"
    #Passenger 3 requires curl headers for compilation
    package "curl-devel" if node[:passenger][:version][0].to_i > 2
  end
else
  %w{ apache2-prefork-dev libapr1-dev }.each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end

gem_package "passenger" do
  version node[:passenger][:version]
end

execute "passenger_module" do
  command 'echo -en "\n\n\n\n" | passenger-install-apache2-module'
  creates node[:passenger][:module_path]
end
