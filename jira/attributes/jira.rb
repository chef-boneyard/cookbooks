#
# Cookbook Name:: jira
# Attributes:: jira
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

jira Mash.new unless attribute?("jira")

jira[:virtual_host_name] = "jira.#{domain}" unless jira.has_key?(:virtual_host_name)
jira[:virtual_host_alias] = "jira.#{domain}" unless jira.has_key?(:virtual_host_alias)
# type-version-standalone
jira[:version] = "enterprise-3.13.1"   unless jira.has_key?(:version)
jira[:install_path] = "/srv/jira"      unless jira.has_key?(:install_path)
jira[:run_user] = "www-data"           unless jira.has_key?(:run_user)
jira[:database] = "mysql"              unless jira.has_key?(:database)
jira[:database_host] = "localhost"     unless jira.has_key?(:database_host)
jira[:database_user] = "jira"          unless jira.has_key?(:database_user)
jira[:database_password] = "change_me" unless jira.has_key?(:database_password)
