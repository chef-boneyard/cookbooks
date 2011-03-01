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
actions :join, :leave

attribute :cluster_name, :kind_of => [String], :name_attribute => true
attribute :cluster_members, :kind_of => [Array]
attribute :node_name, :kind_of => [String], :required => true
attribute :timeout, :kind_of => [Fixnum], :default => 30
attribute :joined, :default => false
attribute :riak_admin_path, :kind_of => [String], :default => "/usr/sbin"
attribute :ring_ready
