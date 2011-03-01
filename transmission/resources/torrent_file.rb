#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: transmission
# Resource:: torrent_file
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

actions :create

attribute :path, :kind_of => String, :name_attribute => true
attribute :torrent, :kind_of => String
attribute :blocking, :default => true
attribute :continue_seeding, :default => false
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :rpc_host, :kind_of => String, :default => 'localhost'
attribute :rpc_port, :kind_of => Integer, :default => 9091
attribute :rpc_username, :kind_of => String, :default => 'transmission'
attribute :rpc_password, :kind_of => String
