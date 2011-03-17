#
# Cookbook Name:: Doat
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
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
user "doat" do
  supports :manage_home => true
  action [:create, :manage]
end

group "doat"

directory "/var/log/doat" do
  mode "0777"
end

common_settings = data_bag_item('doat_config', 'common')
subversion "/opt/doat" do
  repository common_settings['repo_url']
  user "doat"
  group "doat"
  svn_arguments "--non-interactive --no-auth-cache --trust-server-cert"
  svn_info_args "--non-interactive --no-auth-cache --trust-server-cert"
  svn_username common_settings['repo_user']
  svn_password common_settings['repo_password']
end
