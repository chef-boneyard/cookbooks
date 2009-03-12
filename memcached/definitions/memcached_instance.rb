#
# Cookbook Name:: memcached
# Definition:: memcached_instance
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

define :memcached_instance, :memcache_memory => 64, :memcache_port => 11211, :memcache_user => "nobody" do
  include_recipe "runit"
  include_recipe "memcached"
  
  runit_service "memcached-#{params[:name]}" 
end
