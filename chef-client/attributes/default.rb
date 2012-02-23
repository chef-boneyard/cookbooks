#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef
# Attributes:: default
#
# Copyright 2008-2011, Opscode, Inc
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

require 'rbconfig'

default["chef_client"]["interval"]    = "1800"
default["chef_client"]["splay"]       = "20"
default["chef_client"]["log_dir"]     = "/var/log/chef"
default["chef_client"]["conf_dir"]    = "/etc/chef"
default["chef_client"]["bin"]         = "/usr/bin/chef-client"
default["chef_client"]["server_url"]  = "http://localhost:4000"
default["chef_client"]["validation_client_name"] = "chef-validator"
default["chef_client"]["cron"] = { "minute" => "0", "hour" => "*/4" }

case platform
when "arch"
  default["chef_client"]["init_style"]  = "arch"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/cache/chef"
  default["chef_client"]["backup_path"] = "/var/lib/chef"
when "debian","ubuntu","redhat","centos","fedora"
  default["chef_client"]["init_style"]  = "init"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/cache/chef"
  default["chef_client"]["backup_path"] = "/var/lib/chef"
when "openbsd","freebsd","mac_os_x","mac_os_x_server"
  default["chef_client"]["init_style"]  = "bsd"
  default["chef_client"]["run_path"]    = "/var/run"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
when "openindiana","opensolaris","nexentacore","solaris2"
  default["chef_client"]["init_style"]  = "smf"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
when "windows"
  default["chef_client"]["init_style"]  = "winsw"
  default["chef_client"]["run_path"]    = "C:/var/run/chef"
  default["chef_client"]["cache_path"]  = "C:/var/chef/cache"
  default["chef_client"]["backup_path"] = "C:/var/chef/backup"
  default["chef_client"]["conf_dir"]    = "C:/chef"
  default["chef_client"]["bin"]         = File.join(Gem.bindir, "chef-client")
  #Required for minsw wrapper
  default["chef_client"]["ruby_bin"]    = File.join(RbConfig::CONFIG['bindir'], "ruby.exe")
  default["chef_client"]["winsw_url"]   = "http://maven.dyndns.org/2/com/sun/winsw/winsw/1.8/winsw-1.8-bin.exe"
  default["chef_client"]["winsw_dir"]   = "C:/chef/bin"
  default["chef_client"]["winsw_exe"]   = "chef-client.exe"
else
  default["chef_client"]["init_style"]  = "none"
  default["chef_client"]["run_path"]    = "/var/run"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
end
