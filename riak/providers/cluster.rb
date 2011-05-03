#
# Author:: Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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

require 'timeout'
require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut
include Timeout

def load_current_resource
  Chef::Application.fatal!("Can't join a Riak cluster without cluster_members.") if Chef::Config[:solo] && new_resource.cluster_members.empty?
  @current_resource ||= Chef::Resource::RiakCluster.new(new_resource.cluster_name)
  current_resource.ring_ready(ringready)
  Chef::Application.fatal!("Can't join a Riak cluster if the local node is not running.") unless current_resource.ring_ready[:running]
  current_resource.joined(!current_resource.ring_ready[:ready] || current_resource.ring_ready[:members].size > 1)
  if new_resource.cluster_members
    current_resource.cluster_members(new_resource.cluster_members)
  else
    current_resource.cluster_members([])
    search(:node, "riak_core_cluster_name:#{new_resource.cluster_name}") do |n|
      current_resource.cluster_members << n[:riak][:erlang][:node_name]
    end
  end
end

action :join do
  if !current_resource.joined && peer = random_cluster_member
    execute "Joining node #{new_resource.node_name} to Riak cluster #{new_resource.cluster_name}" do
      command "riak-admin join #{peer}"
      path [new_resource.riak_admin_path]
    end
    new_resource.updated_by_last_action(true)
  end
  action_wait_for_ringready
end

action :wait_for_ringready do
  begin
    timeout(new_resource.timeout) do
      wait_for_ring
    end
  rescue Timeout::Error
    Chef::Application.fatal! "Riak cluster ring did not converge within #{new_resource.timeout} seconds!"
  end
end

private

def ringready
  cmd = shell_out("#{new_resource.riak_admin_path}/riak-admin ringready")
  {
    :ready => cmd.stdout =~ /TRUE/,
    :members => cmd.stdout.scan(/'([^',]+)'/).flatten,
    :running => cmd.stdout !~ /Node is not running/
  }
end

def wait_for_ring
  sleep 1 until ringready[:ready]
end

def random_cluster_member
  tmp = current_resource.cluster_members.reject {|n| n == new_resource.node_name }
  tmp[ rand(tmp.size) ]
end
