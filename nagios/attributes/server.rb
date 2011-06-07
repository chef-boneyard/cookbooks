#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Attributes:: server
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
  set['nagios']['server']['install_method'] = 'package'
  set['nagios']['server']['service_name']   = 'nagios3'
when "redhat","centos","fedora","scientific"
  set['nagios']['server']['install_method'] = 'source'
  set['nagios']['server']['service_name']   = 'nagios'
else
  set['nagios']['server']['install_method'] = 'source'
  set['nagios']['server']['service_name']   = 'nagios'
end

set['nagios']['home']       = "/usr/lib/nagios3"
set['nagios']['conf_dir']   = "/etc/nagios3"
set['nagios']['config_dir'] = "/etc/nagios3/conf.d"
set['nagios']['log_dir']    = "/var/log/nagios3"
set['nagios']['cache_dir']  = "/var/cache/nagios3"
set['nagios']['state_dir']  = "/var/lib/nagios3"
set['nagios']['run_dir']    = "/var/run/nagios3"
set['nagios']['docroot']    = "/usr/share/nagios3/htdocs"

# for server from source installation
default['nagios']['server']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagios'
default['nagios']['server']['version']  = '3.2.3'
default['nagios']['server']['checksum'] = '7ec850a4d1d8d8ee36b06419ac912695e29962641c757cf21301b1befcb23434'

default['nagios']['notifications_enabled']   = 0
default['nagios']['check_external_commands'] = true
default['nagios']['default_contact_groups']  = %w(admins)
default['nagios']['sysadmin_email']          = "root@localhost"
default['nagios']['sysadmin_sms_email']      = "root@localhost"
default['nagios']['server_auth_method']      = "openid"

# This setting is effectively sets the minimum interval (in seconds) nagios can handle.
# Other interval settings provided in seconds will calculate their actual from this value, since nagios works in 'time units' rather than allowing definitions everywhere in seconds

default['nagios']['templates'] = Mash.new
default['nagios']['interval_length'] = 1

# Provide all interval values in seconds
default['nagios']['default_host']['check_interval']     = 15
default['nagios']['default_host']['retry_interval']     = 15
default['nagios']['default_host']['max_check_attempts'] = 1
default['nagios']['default_host']['notification_interval'] = 300

default['nagios']['default_service']['check_interval']     = 60
default['nagios']['default_service']['retry_interval']     = 15
default['nagios']['default_service']['max_check_attempts'] = 3
default['nagios']['default_service']['notification_interval'] = 1200
