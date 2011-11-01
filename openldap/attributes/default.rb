# Cookbook Name:: openldap
# Attributes:: openldap
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

#http://help.opscode.com/discussions/problems/290-openldap-fatal-attribute-domain-is-not-defined
#https://gist.github.com/749226

openldap = openldap || {}
domain = node['domain'] || []

if domain.length > 0
  default[:openldap][:basedn] = "dc=#{domain.split('.').join(",dc=")}"
  default[:openldap][:server] = "ldap.#{domain}"
end

openldap[:rootpw] = nil

# File and directory locations for openldap.
case platform
when "redhat","centos"
  set[:openldap][:dir]        = "/etc/openldap"
  set[:openldap][:run_dir]    = "/var/run/openldap"
  set[:openldap][:module_dir] = "/usr/lib64/openldap"  
when "debian","ubuntu"
  set[:openldap][:dir]        = "/etc/ldap"
  set[:openldap][:run_dir]    = "/var/run/slapd"
  set[:openldap][:module_dir] = "/usr/lib/ldap"
else
  set[:openldap][:dir]        = "/etc/ldap"
  set[:openldap][:run_dir]    = "/var/run/slapd"
  set[:openldap][:module_dir] = "/usr/lib/ldap"
end

openldap[:ssl_dir] = "#{openldap[:dir]}/ssl"
openldap[:cafile]  = "#{openldap[:ssl_dir]}/ca.crt"

# Server settings.
openldap[:slapd_type] = nil

if openldap[:slapd_type] == "slave"
  master = search(:nodes, 'openldap_slapd_type:master') 
  default[:openldap][:slapd_master] = master
  default[:openldap][:slapd_replpw] = nil
  default[:openldap][:slapd_rid]    = 102
end

# Auth settings for Apache.
if openldap[:basedn] && openldap[:server]
  default[:openldap][:auth_type]   = "openldap"
  default[:openldap][:auth_binddn] = "ou=people,#{openldap[:basedn]}"
  default[:openldap][:auth_bindpw] = nil
  default[:openldap][:auth_url]    = "ldap://#{openldap[:server]}/#{openldap[:auth_binddn]}?uid?sub?(objecctClass=*)"
end
