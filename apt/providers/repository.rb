#
# Cookbook Name:: apt
# Provider:: repository
#
# Copyright 2010-2011, Opscode, Inc.
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

action :add do
    new_resource.updated_by_last_action(false)

    # add key
    if new_resource.keyserver && new_resource.key
      execute "install-key #{new_resource.key}" do
        command "apt-key adv --keyserver #{new_resource.keyserver} --recv #{new_resource.key}"
        action :nothing
        not_if "apt-key list | grep #{new_resource.key}"
      end.run_action(:run)
    elsif new_resource.key && (new_resource.key =~ /http/)
      key_name = new_resource.key.split(/\//).last
      remote_file "#{Chef::Config[:file_cache_path]}/#{key_name}" do
        source new_resource.key
        mode "0644"
        action :nothing
      end.run_action(:create_if_missing)
      execute "install-key #{key_name}" do
        command "apt-key add #{Chef::Config[:file_cache_path]}/#{key_name}"
        action :nothing
      end.run_action(:run)
    end

    # build our listing
    repo_info = "#{new_resource.uri} #{new_resource.distribution} #{new_resource.components.join(" ")}"
    repository = "deb #{repo_info}\n"
    repository += "deb-src #{repo_info}\n" if new_resource.deb_src

    repo_file = file "/etc/apt/sources.list.d/#{new_resource.repo_name}-source.list" do
      owner "root"
      group "root"
      mode 0644
      content repository
      action :nothing
    end

    # write out the repo file, replace it if it already exists
    repo_file.run_action(:create)

    apt_get_update = execute "apt-get update" do
      ignore_failure true
      action :nothing
    end

    if repo_file.updated_by_last_action?
      new_resource.updated_by_last_action(true)
      apt_get_update.run_action(:run)
    end
end

action :remove do
  if ::File.exists?("/etc/apt/sources.list.d/#{new_resource.repo_name}-source.list")
    Chef::Log.info "Removing #{new_resource.repo_name} repository from /etc/apt/sources.list.d/"
    file "/etc/apt/sources.list.d/#{new_resource.repo_name}-source.list" do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end
