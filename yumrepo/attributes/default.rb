#
# Cookbook Name:: yumrepo
# Attributes:: default[:repo] 
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

default[:repo][:epel][:url] = "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch"
default[:repo][:epel][:enabled] = true
default[:repo][:epel][:key] = "RPM-GPG-KEY-EPEL"
default[:repo][:elff][:url] = "http://download.elff.bravenet.com/5/$basearch"
default[:repo][:elff][:enabled] = true
default[:repo][:elff][:key] = "RPM-GPG-KEY-ELFF"
default[:repo][:dellcommunity][:url] = "http://linux.dell.com/repo/community//mirrors.cgi?osname=el$releasever\&basearch=$basearch"
default[:repo][:dellfirmware][:url] = "http://linux.dell.com/repo/firmware/mirrors.pl?dellsysidpluginver=$dellsysidpluginver"
default[:repo][:dellomsa][:indep][:url] = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver"
default[:repo][:dellomsa][:specific][:url] = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver"
if node[:dmi][:system][:manufacturer] =~ /dell/i and node[:platform_version].to_f >= 5
  default[:repo][:dellcommunity][:enabled] = true
  default[:repo][:dellfirmware][:enabled] = true
  default[:repo][:dellomsa][:enabled] = true
else 
  default[:repo][:dellcommunity][:enabled] = false
  default[:repo][:dellfirmware][:enabled] = false
  default[:repo][:dellomsa][:enabled] = false
end
default[:repo][:vmware][:url] = "http://packages.vmware.com/tools/esx/4.1/rhel5/$basearch"
default[:repo][:vmware][:key] = "VMWARE-PACKAGING-GPG-KEY"
if node[:dmi][:system][:manufacturer] =~ /vmware/i and node[:platform_version].to_f >= 5
  default[:repo][:vmware][:enabled] = true
else
  default[:repo][:vmware][:enabled] = false
end
