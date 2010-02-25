#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Cookbook Name:: nagios
# Attributes:: server
#
# Copyright 2009, 37signals
# Copyright 2009-2010, Opscode, Inc
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
set[:nagios][:dir]       = "/etc/nagios3"
set[:nagios][:log_dir]   = "/var/log/nagios3"
set[:nagios][:cache_dir] = "/var/cache/nagios3"
set[:nagios][:state_dir] = "/var/lib/nagios3"
set[:nagios][:docroot]   = "/usr/share/nagios3/htdocs"
set[:nagios][:config_subdir] = "conf.d"

set_unless[:nagios][:notifications_enabled]   = 0
set_unless[:nagios][:check_external_commands] = true
set_unless[:nagios][:default_contact_groups]  = %w(admins)
set_unless[:nagios][:sysadmin_email]          = "root@localhost"
set_unless[:nagios][:sysadmin_sms_email]      = "root@localhost"

# This setting is effectively sets the minimum interval (in seconds) nagios can handle.
# Other interval settings provided in seconds will calculate their actual from this value, since nagios works in 'time units' rather than allowing definitions everywhere in seconds

set_unless[:nagios][:templates] = Mash.new
set_unless[:nagios][:interval_length] = 1

# Provide all interval values in seconds
set_unless[:nagios][:default_host][:check_interval]     = 15
set_unless[:nagios][:default_host][:retry_interval]     = 15
set_unless[:nagios][:default_host][:max_check_attempts] = 1
set_unless[:nagios][:default_host][:notification_interval] = 300

set_unless[:nagios][:default_service][:check_interval]     = 60
set_unless[:nagios][:default_service][:retry_interval]     = 15
set_unless[:nagios][:default_service][:max_check_attempts] = 3
set_unless[:nagios][:default_service][:notification_interval] = 1200
