#
# Cookbook Name:: django
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
include_recipe "apache2"
include_recipe "apache2::mod_python"
include_recipe "python"

package "apache2-mpm-prefork" do
  action :install
end

package "python-django" do
  action :install
end

# To create a django web app configuration, in a site-cookbook:
# create attributes file with
# node[:django_app][:path]
# node[:django_app][:python_path_extra]

# in the recipe, create the web app resource. don't forget the template:
# web_app "app_name" do
#   docroot "/srv/app_name"
#   template "app_name.conf.erb"
# end
