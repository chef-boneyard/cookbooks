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

include_recipe "apache2"
include_recipe "build-essential"

case node[:platform]
when "arch"
  package "apache"
when "centos","redhat"
  package "httpd-devel"
  if node['platform_version'].to_f < 6.0
    package 'curl-devel'
  else
    package 'libcurl-devel'
    package 'openssl-devel'
    package 'zlib-devel'
  end
else
  %w{ apache2-prefork-dev libapr1-dev libcurl4-gnutls-dev }.each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end

gem_package "passenger" do
  version node[:passenger][:version]
end

execute "passenger_module" do
  command 'passenger-install-apache2-module --auto'
  creates node[:passenger][:module_path]
end
