#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: chrony
# Recipe:: client
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

package "chrony"

service "chrony" do
  supports :restart => true, :status => true, :reload => true
  action [ :enable ]
end

#search for the server, if found populate the template accordingly

template "/etc/chrony/chrony.conf" do
  owner "root"
  group "root"
  mode 0644
  source "chrony.conf.erb"
  notifies :restart, "service[chrony]"
end
