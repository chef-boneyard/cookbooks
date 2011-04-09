#
# Cookbook Name:: yumrepo
# Attributes:: dell 
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

# Dell
default[:repo][:dell][:community_url] = "http://linux.dell.com/repo/community/mirrors.cgi?osname=el#{node[:platform_version].to_i}\&basearch=$basearch"
default[:repo][:dell][:firmware_url] = "http://linux.dell.com/repo/firmware/mirrors.pl?dellsysidpluginver=$dellsysidpluginver"
default[:repo][:dell][:omsa_independent_url] = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver"
default[:repo][:dell][:omsa_specific_url] = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver"
default[:repo][:dell][:download_firmware] = false
if node[:dmi] and node[:dmi][:system] and node[:dmi][:system][:manufacturer] and node[:dmi][:system][:manufacturer] =~ /dell/i and node[:platform_version].to_f >= 5
  set[:repo][:dell][:enabled] = true
else 
  set[:repo][:dell][:enabled] = false
end
