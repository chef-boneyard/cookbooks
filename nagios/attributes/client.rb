#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Attributes:: client
#
# Copyright 2009, 37signals
# Copyright 2009-2011, Opscode, Inc
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

case node['platform']
when "ubuntu","debian"
  set['nagios']['client']['install_method'] = 'package'
when "redhat","centos","fedora","scientific"
  set['nagios']['client']['install_method'] = 'source'
else
  set['nagios']['client']['install_method'] = 'source'
end

set['nagios']['nrpe']['home']       = "/usr/lib/nagios"
set['nagios']['nrpe']['conf_dir']   = "/etc/nagios"

# for plugin from source installation
default['nagios']['plugins']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagiosplug'
default['nagios']['plugins']['version']  = '1.4.15'
default['nagios']['plugins']['checksum'] = '51136e5210e3664e1351550de3aff4a766d9d9fea9a24d09e37b3428ef96fa5b'

# for nrpe from source installation
default['nagios']['nrpe']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagios'
default['nagios']['nrpe']['version']  = '2.12'
default['nagios']['nrpe']['checksum'] = '7e8d093abef7d7ffc7219ad334823bdb612121df40de2dbaec9c6d0adeb04cfc'

default['nagios']['checks']['memory']['critical'] = 150
default['nagios']['checks']['memory']['warning']  = 250
default['nagios']['checks']['load']['critical']   = "30,20,10"
default['nagios']['checks']['load']['warning']    = "15,10,5"
default['nagios']['checks']['smtp_host'] = String.new

default['nagios']['server_role'] = "monitoring"
