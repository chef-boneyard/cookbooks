#
# Author:: David Abdemoulaie <opscode@hobodave.com>
# Cookbook Name:: chef
# Attributes:: server_proxy
#
# Copyright 2009, David Abdemoulaie
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

set_unless[:chef][:doc_root] = "#{languages[:ruby][:gems_dir]}/gems/chef-server-webui-#{chef[:server_version]}/public"

set_unless[:chef][:server_proxy][:css_expire_hours] = "120"
set_unless[:chef][:server_proxy][:js_expire_hours]  = "24"
