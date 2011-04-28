#
# Cookbook Name:: postgresql
# Recipe:: client
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

# Install the postgresql OS packages and the pg gem immediately, so that the
# postgresql_database resource can be used right away.
case node.platform
when "ubuntu","debian"
  %w{postgresql-client libpq-dev}.each do |pkg|
    p = package pkg do
      action :nothing
    end
    p.run_action(:install)
  end
when "fedora","suse"
  p = package "postgresql-devel" do
    action :nothing
  end
  p.run_action(:install)
when "redhat","centos"
  p = package "postgresql#{node.postgresql.version.split('.').join}-devel" do
    action :nothing
  end
  p.run_action(:install)
end

g = gem_package "pg" do
  action :nothing
end
g.run_action(:install)

Gem.clear_paths
require "pg"
