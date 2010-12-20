#
# Cookbook Name:: yumrepo
# Recipe:: vmware-tools 
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
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

if not node[:repo][:vmware][:enabled]
  yumrepo "vmware-tools" do
    action :disable
  end
  return
end

yumrepo "vmware-tools" do
  action :enable
  definition "VMware Tools"
  key "VMWARE-PACKAGING-GPG-KEY"
  url "http://packages.vmware.com/tools/esx/#{repo[:vmware][:release]}/rhel#{node[:platform_version].split('.')[0]}/$basearch"
end

package "VMwareTools" do
  action :remove
end

execute "/usr/bin/vmware-uninstall-tools.pl" do
  action :run
  only_if {File.exists?("/usr/bin/vmware-uninstall-tools.pl")}
end

package "vmware-tools-nox" do
  action :install
end

package "vmware-tools-common" do
  action :install
end

package "vmware-open-vm-tools-common" do
  action :install
end

package "vmware-open-vm-tools-nox" do
  action :install
end

package "vmware-open-vm-tools-kmod" do
  action :install
end

service "vmware-tools" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

if node[:repo][:vmware][:install_optional]
  package "vmware-open-vm-tools-xorg-drv-display" do
    action :install
  end

  package "vmware-open-vm-tools-xorg-drv-mouse" do
    action :install
  end
end

# vim: ai et sts=2 sw=2 ts=2
