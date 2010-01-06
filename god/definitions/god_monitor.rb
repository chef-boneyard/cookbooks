#
# Cookbook Name:: god
# Definition:: god_monitor
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

define :god_monitor, :config => "mongrel.god.erb", :max_memory => 100, :cpu => 50 do
  include_recipe "god"
  
  template "/etc/god/conf.d/#{params[:name]}.god" do
    source params[:config]
    owner "root"
    group "root"
    mode 0644
    variables(
      :name => params[:name],
      :max_memory => params[:max_memory],
      :cpu => params[:cpu],
      :sv_bin => node[:runit][:sv_bin],
      :params => params
    )
    notifies :restart, resources(:service => "god")
  end
  
end
