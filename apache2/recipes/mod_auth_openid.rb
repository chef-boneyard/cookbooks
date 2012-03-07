#
# Cookbook Name:: apache2
# Recipe:: mod_auth_openid
#
# Copyright 2008-2009, Opscode, Inc.
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

openid_dev_pkgs = value_for_platform(
  ["ubuntu","debian"] => { "default" => %w{ g++ apache2-prefork-dev libopkele-dev libopkele3 } },
  ["centos","redhat","scientific","fedora"] => {
    "default" => %w{ gcc-c++ httpd-devel curl-devel libtidy libtidy-devel sqlite-devel pcre-devel openssl-devel make }
  },
  "arch" => { "default" => ["libopkele"] },
  "freebsd" => { "default" => %w{libopkele pcre sqlite3} }
)

make_cmd = value_for_platform(
  "freebsd" => { "default" => "gmake" },
  "default" => "make"
)

case node[:platform]
when "arch"
  include_recipe "pacman"
  package "tidyhtml"
end

openid_dev_pkgs.each do |pkg|
  case node[:platform]
  when "arch"
    pacman_aur pkg do
      action [:build, :install]
    end
  else
    package pkg
  end
end

case node[:platform]
when "redhat", "centos", "scientific", "fedora"
  remote_file "#{Chef::Config[:file_cache_path]}/libopkele-2.0.4.tar.gz" do
    source "http://kin.klever.net/dist/libopkele-2.0.4.tar.gz"
    mode 0644
  end

  bash "install libopkele" do
    cwd "#{Chef::Config[:file_cache_path]}"
    # Ruby 1.8.6 does not have rpartition, unfortunately
    syslibdir = node[:apache][:lib_dir][0..node[:apache][:lib_dir].rindex("/")]
    code <<-EOH
    tar zxvf libopkele-2.0.4.tar.gz
    cd libopkele-2.0.4 && ./configure --prefix=/usr --libdir=#{syslibdir}
    #{make_cmd} && #{make_cmd} install
    EOH
    not_if { File.exists?("#{syslibdir}/libopkele.a") }
  end
end

_checksum = node['apache']['mod_auth_openid']['checksum']
version = node['apache']['mod_auth_openid']['version']
configure_flags = node['apache']['mod_auth_openid']['configure_flags']

remote_file "#{Chef::Config[:file_cache_path]}/mod_auth_openid-#{version}.tar.gz" do
  source "http://butterfat.net/releases/mod_auth_openid/mod_auth_openid-#{version}.tar.gz"
  mode 0644
  checksum _checksum
end

bash "install mod_auth_openid" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar zxvf mod_auth_openid-#{version}.tar.gz
  cd mod_auth_openid-#{version} && ./configure #{configure_flags.join(' ')}
  perl -pi -e "s/-i -a -n 'authopenid'/-i -n 'authopenid'/g" Makefile
  #{make_cmd} && #{make_cmd} install
  EOH
  not_if { ::File.exists?("#{node['apache']['libexecdir']}/mod_auth_openid.so") }
end

directory node[:apache][:mod_auth_openid][:cache_dir] do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode 0700
end

file node[:apache][:mod_auth_openid][:dblocation] do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode 0644
end

template "#{node[:apache][:dir]}/mods-available/authopenid.load" do
  source "mods/authopenid.load.erb"
  owner "root"
  group node[:apache][:root_group]
  mode 0644
end

apache_module "authopenid" do
  filename "mod_auth_openid.so"
end
