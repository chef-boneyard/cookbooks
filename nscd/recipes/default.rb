#
# Cookbook Name:: nscd
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
package "nscd" do
  action :upgrade
end

service "nscd" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

%w{ passwd group }.each do |cmd| 
  execute "nscd-clear-#{cmd}" do
    command "/usr/sbin/nscd -i #{cmd}"
    action :nothing
  end
end
