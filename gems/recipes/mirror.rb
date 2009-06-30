#
# Cookbook Name:: gems
# Recipe:: mirror
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
# Set up a mirror for RubyForge

include_recipe "gems::server"

cron "mirror_rubyforge" do
  command "rsync -av rsync://master.mirror.rubyforge.org/gems/ /srv/gems/gems && gem generate_index -d #{node[:gem_server][:directory]}" 
  hour "2"
  minute "0"
end

# Sync but don't notify generating the index
remote_directory "#{node[:gem_server][:directory]}/gems" do
  source "packages"
  owner "root"
  group "root"
  mode "755"
end