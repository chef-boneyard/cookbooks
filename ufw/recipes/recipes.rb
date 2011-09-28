#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: ufw
# Recipe:: recipes
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

# expand and parse the node's runlist for recipes and find attributes of the form node[<recipe>]['firewall']['rules']
# append them to the node['firewall']['rules'] array attribute
node.expand!.recipes.each do |recipe|
  Chef::Log.debug "ufw::recipes: #{recipe}"
  cookbook = recipe.split('::')[0]
  #get the cookbook attributes if there are any
  if recipe != cookbook and node[cookbook] and node[cookbook]['firewall'] and node[cookbook]['firewall']['rules']
    rules = node[cookbook]['firewall']['rules']
    Chef::Log.debug "ufw::recipes:#{cookbook}:rules #{rules}"
    node['firewall']['rules'].concat(rules) unless rules.nil?
  end
  #get the recipe attributes if there are any
  if node[recipe] and node[recipe]['firewall'] and node[recipe]['firewall']['rules']
    rules = node[recipe]['firewall']['rules']
    Chef::Log.debug "ufw::recipes:#{recipe}:rules #{rules}"
    node['firewall']['rules'].concat(rules) unless rules.nil?
  end
end

#now go apply the rules
include_recipe "ufw::default"
