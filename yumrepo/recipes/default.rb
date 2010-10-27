#
# Cookbook Name:: yumrepo
# Recipe:: default
#
# Copyright 2010, Eric G. Wolfe
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

case node[:platform] when "redhat","centos"
  if node[:platform_version].to_f >= 5 and node[:repo][:epel][:enabled]

    execute "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:epel][:key]}" do
      action :nothing
    end

    execute "yum -q makecache" do
      action :nothing
    end

    cookbook_file "/etc/pki/rpm-gpg/#{node[:repo][:epel][:key]}" do
      mode "0644"
      source node[:repo][:epel][:key]
      notifies :run, resources(:execute => "rpm --import /etc/pki/rpm-gpg/#{node[:repo][:epel][:key]}"), :immediately
    end

    template "/etc/yum.repos.d/epel.repo" do
      mode "0644"
      source "epel.repo.erb"
      notifies :run, resources(:execute => "yum -q makecache"), :immediately
    end

  end
end
