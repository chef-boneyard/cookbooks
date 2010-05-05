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

class Chef::Resource::Template
  include RiakTemplateHelper
end

version_str = "#{node[:riak][:package][:version][:major]}.#{node[:riak][:package][:version][:minor]}"
base_uri = "http://downloads.basho.com/riak/riak-#{version_str}/"
base_filename = "riak-#{version_str}.#{node[:riak][:package][:version][:incremental]}"

user "riak" do
  gid "nogroup"
  shell "/bin/false"
  home "/tmp"
end

package_file =  case node[:riak][:package][:type]
                when "binary"
                  case node[:platform]
                  when "debian","ubuntu"
                    include_recipe "riak::iptables"
                    machines = {"x86_64" => "amd64", "i386" => "i386"} 
                    "#{base_filename.gsub(/\-/, '_')}-1_#{machines[node[:kernel][:machine]]}.deb"
                  when "centos","redhat","fedora","suse"
                    "#{base_filename}-1.#{node[:kernel][:machine]}.rpm"
                  # when "mac_os_x"
                  #  "#{base_filename}.osx.#{node[:kernel][:machine]}.tar.gz"
                  end
                when "source"
                  "#{base_filename}.tar.gz"
                end

directory "/tmp/riak_pkg" do
  owner "root"
  mode "0755"
  action :create
end

remote_file "/tmp/riak_pkg/#{package_file}" do
  source base_uri + package_file
  owner "root"
  mode "0644"
end

case node[:riak][:package][:type]
when "binary"
  package "riak" do
    source "/tmp/riak_pkg/#{package_file}"
    action :install
    provider value_for_platform(
      [ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
      [ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
    )
  end
when "source"
  execute "riak-src-unpack" do
    cwd "/tmp/riak_pkg"    
    command "tar xvfz #{package_file}"
  end
  
  execute "riak-src-build" do
    cwd "/tmp/riak_pkg/#{base_filename}"
    command "make clean && make all && make rel"
  end
  
  execute "riak-src-install" do
    command "mv /tmp/riak_pkg/#{base_filename}/rel/riak #{node[:riak][:package][:prefix]}"
    not_if "test -d #{node[:riak][:package][:prefix]}/riak"
  end
end

case node[:riak][:kv][:storage_backend]
when "innostore_riak"
  include_recipe "riak::innostore"
end

directory "/etc/riak" do
  owner "root"
  mode "0755"
  action :create
  not_if "test -d /etc/riak"
end

template "/etc/riak/app.config" do
  variables({:config => configify(node[:riak].to_hash),
             :limit_port_range => node[:riak][:limit_port_range],
             :storage_backend => node[:riak][:kv][:storage_backend]})
  source "app.config.erb"
  owner "root"
  mode 0644
end

vm_args = node[:riak][:erlang].to_hash
env_vars = vm_args.delete("env_vars")
template "/etc/riak/vm.args" do
  variables({
      :arg_map => {
        "node_name" => "-name",
        "cookie" => "-setcookie",
        "heart" => "-heart",
        "kernel_polling" => "+K",
        "async_threads" => "+A",
        "smp" => "-smp"
      },
      :vm_args => vm_args,
      :env_vars => env_vars
    })
  
  source "vm.args.erb"
  owner "root"
  mode 0644
end

if node[:riak][:package][:type].eql?("binary")
  service "riak" do
    supports :start => true, :stop => true, :status => true, :restart => true
    action [ :enable ]
    subscribes :restart, resources(:template => "/etc/riak/app.config", :template => "/etc/riak/vm.args")
  end
end
