#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: ufw
# Recipe:: securitylevel
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

securitylevel = node['firewall']['securitylevel']

Chef::Log.info "ufw::securitylevel:#{securitylevel}"

#verify that only 1 "color" security group is applied"
count = node.expand!.roles.count {|role| role =~ /SecurityLevel-(Red|Green|Yellow)/ }
if count > 1
  raise Chef::Exceptions::AmbiguousRunlistSpecification, "conflicting SecurityLevel-'color' roles, only 1 may be applied."
end

case securitylevel
when 'red'
  #put special stuff for red here
when 'yellow'
  #put special stuff for red here
when 'green'
  #put special stuff for red here
end

#now go apply the rules
include_recipe "ufw::default"
