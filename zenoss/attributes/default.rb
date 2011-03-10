#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: zenoss
# Attributes:: default
#
# Copyright 2010, Zenoss, Inc
# Copyright 2010, 2011 Opscode, Inc
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

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:zenoss][:server][:admin_password] = secure_password

default[:zenoss][:device][:device_class]    = "/Discovered" #overwritten by roles or on nodes
default[:zenoss][:device][:location]        = "" #overwritten by roles or on nodes
default[:zenoss][:device][:modeler_plugins] = [] #overwritten by roles or on nodes
default[:zenoss][:device][:properties]      = {} #overwritten by roles or on nodes
default[:zenoss][:device][:templates]       = [] #overwritten by roles or on nodes
default[:zenoss][:server][:version]         = "3.1.0-0"
default[:zenoss][:server][:zenhome]         = "/usr/local/zenoss/zenoss" #RPM is different
default[:zenoss][:server][:zenoss_pubkey]   = "" #gets set in the server recipe, read by clients

#it might matter that these get ordered eventually
default[:zenoss][:server][:installed_zenpacks] = {
  "ZenPacks.zenoss.DeviceSearch" => "1.0.0",
  "ZenPacks.zenoss.LinuxMonitor"  => "1.1.5",
  "ZenPacks.community.MySQLSSH"  => "0.4",
}

#it might matter that these get ordered eventually as well
default[:zenoss][:server][:zenpatches] = {
  "25711" => "http://dev.zenoss.com/trac/ticket/7497",
  "25814" => "http://dev.zenoss.com/trac/ticket/7772",
  "25902" => "http://dev.zenoss.com/trac/ticket/7591",
  "25926" => "http://dev.zenoss.com/trac/ticket/7802",
  "25963" => "http://dev.zenoss.com/trac/ticket/7114",
  "26025" => "http://dev.zenoss.com/trac/ticket/7813",
}
