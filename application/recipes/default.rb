#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

search(:apps) do |app|
  (app["server_roles"] & node.run_list.roles).each do |app_role|
    app["type"][app_role].each do |thing|
      node.run_state[:current_app] = app
      # Force include_recipe
      node.run_state[:seen_recipes].delete("application::#{thing}")
      include_recipe "application::#{thing}"
    end
  end
end

node.run_state.delete(:current_app)

