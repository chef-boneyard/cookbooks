#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "java"
include_recipe "capistrano"
include_recipe "runit"

group node[:solr][:group] do
  gid node[:solr][:gid]
  action :create
end

user node[:solr][:user] do
  comment "Solr replication"
  home "/srv/solr"
  shell "/bin/bash"
  uid node[:solr][:uid]
  gid node[:solr][:gid]
  action :create
end
