#
# Cookbook Name:: jira
# Attributes:: jira
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

set_unless[:jira][:virtual_host_name]  = "jira.#{domain}"
set_unless[:jira][:virtual_host_alias] = "jira.#{domain}"
# type-version-standalone
set_unless[:jira][:version]           = "enterprise-3.13.1"
set_unless[:jira][:install_path]      = "/srv/jira"
set_unless[:jira][:run_user]          = "www-data"
set_unless[:jira][:database]          = "mysql"
set_unless[:jira][:database_host]     = "localhost"
set_unless[:jira][:database_user]     = "jira"
set_unless[:jira][:database_password] = "change_me"
