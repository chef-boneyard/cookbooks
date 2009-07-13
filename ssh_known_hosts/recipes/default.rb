#
# Cookbook Name:: ssh_known_hosts
# Recipe:: default
#
# Copyright 2009, Scott M. Likens
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

nodes = []
search(:node, "*", %w{ keys_ssh_host_rsa_public ipaddress hostname }) {|n| nodes << n}

template "/etc/ssh/ssh_known_hosts" do
  source "known_hosts.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :nodes => nodes
  )
end
