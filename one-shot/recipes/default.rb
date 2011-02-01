#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: one-shot
# Recipe:: default
#
# Copyright 2011, Opscode, Inc
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

oneshot = node["one_shot"]["recipe"]

include_recipe oneshot

ruby_block "remove one-shot recipe #{oneshot}" do
  block do
    Chef::Log.info("One-Shot recipe #{oneshot} executed and removed from run_list")
    node.run_list.remove("recipe[one-shot]") if node.run_list.include?("recipe[one-shot]")
  end
  action :create
end
