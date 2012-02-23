#
# Cookbook Name:: apache2
# Attributes:: apache
#
# Copyright 2008-2009, Opscode, Inc.
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

set[:apache][:root_group]  = "root"

# Where the various parts of apache are
case platform
when "redhat","centos","scientific","fedora","suse"
  set[:apache][:package] = "httpd"
  set[:apache][:dir]     = "/etc/httpd"
  set[:apache][:log_dir] = "/var/log/httpd"
  set[:apache][:error_log] = "error.log"
  set[:apache][:user]    = "apache"
  set[:apache][:group]   = "apache"
  set[:apache][:binary]  = "/usr/sbin/httpd"
  set[:apache][:icondir] = "/var/www/icons"
  set[:apache][:cache_dir] = "/var/cache/httpd"
  if node.platform_version.to_f >= 6 then
    set[:apache][:pid_file] = "/var/run/httpd/httpd.pid"
  else
    set[:apache][:pid_file] = "/var/run/httpd.pid"
  end
  set[:apache][:lib_dir] = node[:kernel][:machine] =~ /^i[36]86$/ ? "/usr/lib/httpd" : "/usr/lib64/httpd"
  set[:apache][:libexecdir] = "#{set[:apache][:lib_dir]}/modules"
when "debian","ubuntu"
  set[:apache][:package] = "apache2"
  set[:apache][:dir]     = "/etc/apache2"
  set[:apache][:log_dir] = "/var/log/apache2"
  set[:apache][:error_log] = "error.log"
  set[:apache][:user]    = "www-data"
  set[:apache][:group]   = "www-data"
  set[:apache][:binary]  = "/usr/sbin/apache2"
  set[:apache][:icondir] = "/usr/share/apache2/icons"
  set[:apache][:cache_dir] = "/var/cache/apache2"
  set[:apache][:pid_file]  = "/var/run/apache2.pid"
  set[:apache][:lib_dir] = "/usr/lib/apache2"
  set[:apache][:libexecdir] = "#{set[:apache][:lib_dir]}/modules"
when "arch"
  set[:apache][:package] = "apache"
  set[:apache][:dir]     = "/etc/httpd"
  set[:apache][:log_dir] = "/var/log/httpd"
  set[:apache][:error_log] = "error.log"
  set[:apache][:user]    = "http"
  set[:apache][:group]   = "http"
  set[:apache][:binary]  = "/usr/sbin/httpd"
  set[:apache][:icondir] = "/usr/share/httpd/icons"
  set[:apache][:cache_dir] = "/var/cache/httpd"
  set[:apache][:pid_file]  = "/var/run/httpd/httpd.pid"
  set[:apache][:lib_dir] = "/usr/lib/httpd"
  set[:apache][:libexecdir] = "#{set[:apache][:lib_dir]}/modules"
when "freebsd"
  set[:apache][:package] = "apache22"
  set[:apache][:dir]     = "/usr/local/etc/apache22"
  set[:apache][:log_dir] = "/var/log"
  set[:apache][:error_log] = "httpd-error.log"
  set[:apache][:root_group] = "wheel"
  set[:apache][:user]    = "www"
  set[:apache][:group]    = "www"
  set[:apache][:binary]  = "/usr/local/sbin/httpd"
  set[:apache][:icondir] = "/usr/local/www/apache22/icons"
  set[:apache][:cache_dir] = "/var/run/apache22"
  set[:apache][:pid_file]  = "/var/run/httpd.pid"
  set[:apache][:lib_dir] = "/usr/local/libexec/apache22"
  set[:apache][:libexecdir] = set[:apache][:lib_dir]
else
  set[:apache][:dir]     = "/etc/apache2"
  set[:apache][:log_dir] = "/var/log/apache2"
  set[:apache][:error_log] = "error.log"
  set[:apache][:user]    = "www-data"
  set[:apache][:group]   = "www-data"
  set[:apache][:binary]  = "/usr/sbin/apache2"
  set[:apache][:icondir] = "/usr/share/apache2/icons"
  set[:apache][:cache_dir] = "/var/cache/apache2"
  set[:apache][:pid_file]  = "logs/httpd.pid"
  set[:apache][:lib_dir] = "/usr/lib/apache2"
  set[:apache][:libexecdir] = "#{set[:apache][:lib_dir]}/modules"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:apache][:listen_ports] = [ "80","443" ]
default[:apache][:contact] = "ops@example.com"
default[:apache][:timeout] = 300
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 5

# Security
default[:apache][:servertokens] = "Prod"
default[:apache][:serversignature] = "On"
default[:apache][:traceenable] = "On"

# mod_auth_openids
default[:apache][:allowed_openids] = Array.new

# Prefork Attributes
default[:apache][:prefork][:startservers] = 16
default[:apache][:prefork][:minspareservers] = 16
default[:apache][:prefork][:maxspareservers] = 32
default[:apache][:prefork][:serverlimit] = 400
default[:apache][:prefork][:maxclients] = 400
default[:apache][:prefork][:maxrequestsperchild] = 10000

# Worker Attributes
default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 0

# Default modules to enable via include_recipe

default['apache']['default_modules'] = %w{
  status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
  dir env mime negotiation setenvif
}

default['apache']['default_modules'] << "log_config" if ["redhat", "centos", "scientific", "fedora", "suse", "arch", "freebsd"].include?(node.platform)
