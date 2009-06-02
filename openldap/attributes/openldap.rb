# Cookbook Name:: openldap
# Attributes:: openldap
#
# Copyright 2008, Opscode, Inc.
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

openldap Mash.new unless attribute?("openldap")

if domain.length > 0
  openldap[:basedn] = "dc=#{domain.split('.').join(",dc=")}" unless openldap.has_key?(:basedn)
  openldap[:server] = "ldap.#{domain}" unless openldap.has_key?(:server)
end

openldap[:rootpw] = nil unless openldap.has_key?(:rootpw)

# File and directory locations for openldap.
case platform
when "redhat","centos"
  openldap[:dir] = "/etc/openldap"
  openldap[:run_dir] = "/var/run/openldap"
  openldap[:module_dir] = "/usr/lib64/openldap"  
when "debian","ubuntu"
  openldap[:dir] = "/etc/ldap"
  openldap[:run_dir] = "/var/run/slapd"
  openldap[:module_dir] = "/usr/lib/ldap"
else
  openldap[:dir] = "/etc/ldap"
  openldap[:run_dir] = "/var/run/slapd"
  openldap[:module_dir] = "/usr/lib/ldap"
end

openldap[:ssl_dir] = "#{openldap[:dir]}/ssl"
openldap[:cafile] = "#{openldap[:ssl_dir]}/ca.crt"

# Server settings.
openldap[:slapd_type] = nil unless openldap.has_key?(:slapd_type)

if openldap[:slapd_type] == "slave"
  master = search(:nodes, 'openldap_slapd_type:master') 
  openldap[:slapd_master] = master unless openldap.has_key?(:slapd_master)
  openldap[:slapd_replpw] = nil unless openldap.has_key?(:slapd_replpw)
  openldap[:slapd_rid] = 102 unless openldap.has_key?(:slapd_rid)
end

# Auth settings for Apache.
if openldap[:basedn] && openldap[:server]
  openldap[:auth_type] = "openldap"
  openldap[:auth_binddn] = "ou=people,#{openldap[:basedn]}" unless openldap.has_key?(:auth_binddn)
  openldap[:auth_bindpw] = nil unless openldap.has_key?(:auth_bindpw)
  openldap[:auth_url] = "ldap://#{openldap[:server]}/#{openldap[:auth_binddn]}?uid?sub?(objecctClass=*)" unless openldap.has_key?(:auth_url)
end