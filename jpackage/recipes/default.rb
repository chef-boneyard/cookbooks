#
# Cookbook Name:: jpackage
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

case node[:platform]
when "redhat","centos","fedora"
  
  package "yum-priorities" do
    action :install
  end
  
  execute "yum clean all" do
    action :nothing
  end
  
  template "/etc/yum.repos.d/jpackage#{node[:jpackage][:version].sub(/\./,'')}.repo" do
    mode "0644"
    source "jpackage.repo.erb"
    notifies :run, resources(:execute => "yum clean all"), :immediately
  end
  
  # fix the jpackage-utils issue
  # https://bugzilla.redhat.com/show_bug.cgi?id=497213
  # http://plone.lucidsolutions.co.nz/linux/centos/jpackage-jpackage-utils-compatibility-for-centos-5.x
  remote_file "#{Chef::Config[:file_cache_path]}/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm" do
    checksum "c61f2a97e4cda0781635310a6a595e978a2e48e64cf869df7d339f0db6a28093"
    source "http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm"
    mode "0644"
  end
  
  package "jpackage-utils-compat-el5" do
    source "#{Chef::Config[:file_cache_path]}/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm"
    options "--nogpgcheck" 
    version "0.0.1"
    action :install
  end
  
  package "jpackage-utils" do
    action :install
  end
end