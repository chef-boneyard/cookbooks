#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: firwall
# Resource:: rule
#
# Copyright:: 2011, Opscode, Inc.
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

IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/

actions :allow, :deny, :reject

attribute :port, :kind_of => Integer
attribute :protocol, :kind_of => Symbol, :equal_to => [ :udp, :tcp ]
attribute :direction, :kind_of => Symbol, :equal_to => [ :in, :out ]
attribute :interface, :kind_of => String
attribute :logging, :kind_of => Symbol, :equal_to => [ :connections, :packets ]
attribute :source, :regex => IP_CIDR_VALID_REGEX
attribute :destination, :regex => IP_CIDR_VALID_REGEX
attribute :dest_port, :kind_of => Integer
attribute :position, :kind_of => Integer

def initialize(name, run_context=nil)
  super
  set_platform_default_providers
end

private
def set_platform_default_providers
  Chef::Platform.set(
    :platform => :ubuntu,
    :resource => :firewall_rule,
    :provider => Chef::Provider::FirewallRuleUfw
  )
end