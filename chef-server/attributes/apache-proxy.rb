#
# Author:: David Abdemoulaie <opscode@hobodave.com>
# Cookbook Name:: chef-server
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

include_attribute "apache2"
include_attribute "chef-server"

default['chef_server']['doc_root'] = "#{node['languages']['ruby']['gems_dir']}/gems/chef-server-webui-#{node['chef_packages']['chef']['version']}/public"
default['chef_server']['ssl_req']  = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=chef-server-proxy/emailAddress=root@localhost"
default['chef_server']['proxy']['css_expire_hours'] = "120"
default['chef_server']['proxy']['js_expire_hours']  = "24"
