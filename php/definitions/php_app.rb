#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: php
# Recipe:: php_app
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
# php_app will be deprecated for web_app (apache2 cookbook).

define :php_app, :docroot => nil, :canonical_hostname => nil, :template => "php/php.conf.erb" do
  
  application_name = params[:name]
  
  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  template "/etc/apache2/sites-available/#{params[:name]}.conf" do
    source "#{params[:template]}"
    variables :docroot => params[:docroot], :canonical_hostname => params[:canonical_hostname]
    owner "root"
    group "root"
    mode 0644
    notifies :reload, resources("service[apache2]"), :delayed
  end
  
  apache_site "#{params[:name]}.conf"
  
end
