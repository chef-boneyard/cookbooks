#
# Author:: Benjamin Black (<b@b3k.us>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2010 Basho Technologies, Inc.
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

riak_version = "0.10"
base_uri = "http://downloads.basho.com/riak/riak-#{riak_version}/"
base_filename = "riak-#{riak_version}"

service "riak" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

user "riak" do
  gid "nogroup"
  shell "/bin/false"
end

package_file =  case node[:riak][:package][:type]
                when "binary"
                  case node[:platform]
                  when "debian","ubuntu"
                    include_recipe "riak::iptables"
                    "#{base_filename.gsub(/\-/, '_')}-1_#{node[:machine]}.deb"
                  when "centos","redhat","fedora","suse"
                    "#{base_filename}-1.#{node[:machine]}.rpm"
                  # when "mac_os_x"
                  #  "#{base_filename}.osx.#{node[:machine]}.tar.gz"
                  end
                when "source"
                  include_recipe "mercurial"
                  "#{base_filename}.tar.gz"
                end

remote_file "/tmp/riak_pkg/#{package_file}" do
  source base_uri + package_file
  mode "0644"
end

case node[:riak][:package][:type]
when "binary"
  package "riak-server" do
    source package_file
    action :install
  end
when "source"
  execute "riak-src-unpack" do
    cwd "/tmp/riak_pkg"    
    command "tar xvfz #{package_file}"
  end
  
  execute "riak-src-build" do
    cwd "/tmp/riak_pkg/#{base_filename}"
    command "make rel"
  end
  
  execute "riak-src-install" do
    command "mv /tmp/riak_pkg/#{base_filename}/rel/riak /usr/local"
    not_if "test -d /usr/local/riak"
  end
end

case node[:riak][:kv][:storage_backend]
when "innostore"
  include_recipe "riak::innostore"
end

directory "/etc/riak" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if "test -d /etc/riak"
end

template "/etc/riak/app.config" do
  variables({:config => node[:riak]})
  source "app.config.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "riak")
end

template "/etc/riak/vm.args" do
  variables({
      :arg_map => {
        "node_name" => "-name",
        "cookie" => "-cookie",
        "heart" => "-heart",
        "kernel_polling" => "+K",
        "async_threads" => "+A",
        "env_vars" => "-env"
      }
    })
  
  source "vm.args.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "riak")
end