#
# Cookbook Name:: instiki
# Recipe:: default
#
# Copyright 2009, Opscode
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

include_recipe "sqlite"
include_recipe "rails"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "passenger_apache2"
include_recipe "passenger_apache2::mod_rails"

remote_file "/tmp/instiki-0.17.tar.gz" do
  source "http://rubyforge.org/frs/download.php/59127/instiki-0.17.tgz"
  mode 0644
  owner "root"
  group "root"
  not_if { ::FileTest.exists?("/tmp/instiki-0.17.tar.gz") }
end

directory "/srv/instiki" do
  owner node[:apache][:user]
end

execute "tar zxf /tmp/instiki-0.17.tar.gz -C /srv/instiki" do
  user node[:apache][:user]
  creates "/srv/instiki/instiki-0.17/instiki"
end

web_app "instiki" do
  docroot "/srv/instiki/instiki-0.17/public"
  template "instiki.conf.erb"
  server_name "wiki.#{node[:domain]}"
  server_aliases [ "wiki", "instiki", node[:hostname] ]
  rails_env "production"
end
