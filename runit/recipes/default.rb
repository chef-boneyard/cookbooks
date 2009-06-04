#
# Cookbook Name:: runit
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

case node[:platform]
when "debian","ubuntu"
  execute "start-runsvdir" do
    case node[:platform]
    when "debian"
      command "runsvdir-start"
    else
      command "start runsvdir"
    end
    action :nothing
  end
  
  package "runit" do
    action :install
    notifies :run, resources(:execute => "start-runsvdir")
  end
    
  if node[:platform_version].to_f <= 8.04 && node[:platform] =~ /ubuntu/i
    remote_file "/etc/event.d/runsvdir" do
      source "runsvdir"
      mode 0644
      notifies :run, resources(:execute => "start-runsvdir")
    end
    
    file "/etc/inittab" do
      action :touch
    end
  end
end
