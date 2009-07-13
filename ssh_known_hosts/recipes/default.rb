#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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

require 'chef/log'

my_hostname = []
my_host_rsa_public = []
my_host_ip = []

keys = []
search(:node, "*") do |server|
  server['keys_ssh_host_rsa_public'].each do |x|
    Chef::Log.debug("SSH RSA Key #{x}")
    my_host_rsa_public << x
    end
  server['ipaddress'].each do |y|
    Chef::Log.debug("IP Address #{y}")
    my_host_ip << y
    end
  server['hostname'].each do |z|
    Chef::Log.debug("hostname #{z}")
    my_hostname << z
    end
  end

template "/etc/ssh/known_hosts" do
  source "known_hosts.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :ip => my_host_ip,
    :hostname => my_hostname,
    :host_rsa_public => my_host_rsa_public
  )
end
