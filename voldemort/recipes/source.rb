#
# Author:: John E. Vincent <lusis.org+github.com@gmail.com>
# Cookbook Name:: voldemort
# Recipe:: source
#
# Copyright 2010, John E. Vincent
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


voldemort_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "voldemort-#{node[:voldemort][:version]}.tar.gz")

remote_file voldemort_tar_gz do
  source "#{node[:voldemort][:mirror]}/voldemort-#{node[:voldemort][:version]}.tar.gz"
end

user "voldemort" do
  home node[:voldemort][:home_dir]
  comment "Voldemort System Account"
  supports :manage_home => false
  system true
end

directory node[:voldemort][:install_dir] do
  owner "voldemort"
  group "voldemort"
  mode "0644"
end

bash "install voldemort #{node[:voldemort][:version]}" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -C #{node[:voldemort][:install_dir]} -zxf #{voldemort_tar_gz}
  EOH
  not_if { ::FileTest.exists?("#{node[:voldemort][:install_dir]}/voldemort-#{node[:voldemort][:version]}/bin/voldemort-server.sh") }
end

directory node[:voldemort][:home_dir] do
  owner "voldemort"
  group "voldemort"
  mode "0644"
end

directory node[:voldemort][:data_dir] do
  owner "voldemort"
  group "voldemort"
  mode "0640"
end

directory "#{node[:voldemort][:config_dir]}/config" do
  owner "voldemort"
  group "voldemort"
  mode "0640"
  recursive true
end

directory node[:voldemort][:log_dir] do
  owner "voldemort"
  group "voldemort"
  mode "0644"
end

if node[:voldemort][:do_symlink] == true then
  link node[:voldemort][:run_dir] do
    to "#{node[:voldemort][:install_dir]}/voldemort-#{node[:voldemort][:version]}"
  end
end
