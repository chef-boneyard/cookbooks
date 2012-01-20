#
# Cookbook Name:: munin
# Attributes:: default
#
# Copyright 2010-2011, Opscode, Inc.
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

default['munin']['sysadmin_email'] = "ops@example.com"
default['munin']['server_role'] = 'monitoring'
default['munin']['server_auth_method'] = 'openid'

case node[:platform]
when "arch"
  default['munin']['basedir'] = "/etc/munin"
  default['munin']['plugin_dir'] = "/usr/share/munin/plugins"
  default['munin']['docroot'] = "/srv/http/munin"
  default['munin']['dbdir'] = "/var/lib/munin"
  default['munin']['root']['group'] = "root"
when "centos","redhat"
  default['munin']['basedir'] = "/etc/munin"
  default['munin']['plugin_dir'] = "/usr/share/munin/plugins"
  default['munin']['docroot'] = "/var/www/html/munin"
  default['munin']['dbdir'] = "/var/lib/munin"
  default['munin']['root']['group'] = "root"
when "freebsd"
  default['munin']['basedir'] = "/usr/local/etc/munin"
  default['munin']['plugin_dir'] = "/usr/local/share/munin/plugins"
  default['munin']['docroot'] = "/usr/local/www/munin"
  default['munin']['dbdir'] = "/usr/local/var/munin"
  default['munin']['root']['group'] = "wheel"
else
  default['munin']['basedir'] = "/etc/munin"
  default['munin']['plugin_dir'] = "/usr/share/munin/plugins"
  default['munin']['docroot'] = "/var/www/munin"
  default['munin']['dbdir'] = "/var/lib/munin"
  default['munin']['root']['group'] = "root"
end

default['munin']['plugins'] = "#{default['munin']['basedir']}/plugins"
default['munin']['tmpldir'] = "#{default['munin']['basedir']}/templates"
