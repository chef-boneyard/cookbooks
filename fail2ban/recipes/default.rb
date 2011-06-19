#
# Cookbook Name:: fail2ban
# Recipe:: default
#
# Copyright 2009-2011, Opscode, Inc.
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
package "fail2ban" do
  action :upgrade
end

%w{ fail2ban jail }.each do |cfg|
  template "/etc/fail2ban/#{cfg}.conf" do
    source "#{cfg}.conf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[fail2ban]"
  end
end

service "fail2ban" do
  supports [ :status => true, :restart => true ]
  action [ :enable, :start ]
end
