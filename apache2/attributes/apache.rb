#
# Cookbook Name:: apache2
# Attributes:: apache
#
# Copyright 2008, OpsCode, Inc.
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

apache Mash.new unless attribute?("apache")

# Where the various parts of apache are
case platform
when "redhat","centos","fedora","suse"
  apache[:dir]     = "/etc/httpd"
  apache[:log_dir] = "/var/log/httpd"
  apache[:user]    = "apache"
  apache[:binary]  = "/usr/sbin/httpd"
  apache[:icondir] = "/var/www/icons/"
when "debian","ubuntu"
  apache[:dir]     = "/etc/apache2" 
  apache[:log_dir] = "/var/log/apache2"
  apache[:user]    = "www-data"
  apache[:binary]  = "/usr/sbin/apache2"
  apache[:icondir] = "/usr/share/apache2/icons"
else
  apache[:dir]     = "/etc/apache2" 
  apache[:log_dir] = "/var/log/apache2"
  apache[:user]    = "www-data"
  apache[:binary]  = "/usr/sbin/apache2"
  apache[:icondir] = "/usr/share/apache2/icons"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
apache[:listen_ports] = [ "80","443" ]     unless apache.has_key?(:listen_ports)
apache[:contact] = "ops@example.com" unless apache.has_key?(:contact)
apache[:timeout] = 300               unless apache.has_key?(:timeout)
apache[:keepalive] = "On"            unless apache.has_key?(:keepalive)
apache[:keepaliverequests] = 100     unless apache.has_key?(:keepaliverequests)
apache[:keepalivetimeout] = 5        unless apache.has_key?(:keepalivetimeout)

# Security
apache[:servertokens] = "Prod"  unless apache.has_key?(:servertokens)
apache[:serversignature] = "On" unless apache.has_key?(:serversignature)
apache[:traceenable] = "On"     unless apache.has_key?(:traceenable)

# Prefork Attributes
apache[:prefork] = Mash.new unless apache.has_key?(:prefork)
apache[:prefork][:startservers] = 16      unless apache[:prefork].has_key?(:startservers)
apache[:prefork][:minspareservers] = 16   unless apache[:prefork].has_key?(:minspareservers)
apache[:prefork][:maxspareservers] = 32   unless apache[:prefork].has_key?(:maxspareservers)
apache[:prefork][:serverlimit] = 400      unless apache[:prefork].has_key?(:serverlimit)
apache[:prefork][:maxclients] = 400       unless apache[:prefork].has_key?(:maxclients)
apache[:prefork][:maxrequestsperchild] = 10000 unless apache[:prefork].has_key?(:maxrequestsperchild)

# Worker Attributes
apache[:worker] = Mash.new unless apache.has_key?(:worker)
apache[:worker][:startservers] = 4        unless apache[:worker].has_key?(:startservers)
apache[:worker][:maxclients] = 1024       unless apache[:worker].has_key?(:maxclients)
apache[:worker][:minsparethreads] = 64    unless apache[:worker].has_key?(:minsparethreads)
apache[:worker][:maxsparethreads] = 192   unless apache[:worker].has_key?(:maxsparethreads)
apache[:worker][:threadsperchild] = 64    unless apache[:worker].has_key?(:threadsperchild)
apache[:worker][:maxrequestsperchild] = 0 unless apache[:worker].has_key?(:maxrequestsperchild)
