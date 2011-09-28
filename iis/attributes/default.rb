#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: iis
# Attribute:: default
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

default['iis']['accept_eula'] = false

default['iis']['home']      = "#{ENV['WINDIR']}\\System32\\inetsrv"
default['iis']['conf_dir']  = "#{iis['home']}\\config"
default['iis']['pubroot']   = "#{ENV['SYSTEMDRIVE']}\\inetpub"
default['iis']['docroot']   = "#{iis['pubroot']}\\wwwroot"
default['iis']['log_dir']   = "#{iis['pubroot']}\\logs\\LogFiles"
default['iis']['cache_dir'] = "#{iis['pubroot']}\\temp"