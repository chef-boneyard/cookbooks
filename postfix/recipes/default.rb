#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2009-2012, Opscode, Inc.
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

package "postfix"

if node['postfix']['use_procmail']

  package "procmail"

end


service "postfix" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

case node['platform_family']
when "rhel", "fedora"

  service "sendmail" do
    action :nothing
  end

  execute "switch_mailer_to_postfix" do
    command "/usr/sbin/alternatives --set mta /usr/sbin/sendmail.postfix"
    notifies :stop, "service[sendmail]"
    notifies :start, "service[postfix]"
    not_if "/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix"
  end

end

%w{main master}.each do |cfg|

  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner "root"
    group 0
    mode 00644
    notifies :restart, "service[postfix]"

  end
end

service "postfix" do
  action :start
end
