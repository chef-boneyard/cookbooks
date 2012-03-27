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

# install apt key from keyserver
def install_key_from_keyserver(key, keyserver)
  unless system("apt-key list | grep #{key}")
    execute "install-key #{key}" do
      command "apt-key adv --keyserver #{keyserver} --recv #{key}"
      action :nothing
    end.run_action(:run)
    new_resource.updated_by_last_action(true)
  end
end

# install apt key from URI
def install_key_from_uri(uri)
  key_name = uri.split(/\//).last
  cached_keyfile = "#{Chef::Config[:file_cache_path]}/#{key_name}"
  if (new_resource.key =~ /http/)
    r = remote_file cached_keyfile do
      source new_resource.key
      mode "0644"
      action :nothing
    end
  else
    r = cookbook_file cached_keyfile do
      source new_resource.key
      cookbook new_resource.cookbook
      mode "0644"
      action :nothing
    end
  end

  r.run_action(:create)

  execute "install-key #{key_name}" do
    command "apt-key add #{cached_keyfile}"
    action :nothing
  end.run_action(:run)
  new_resource.updated_by_last_action(true)
end

# build repo file contents
def build_repo(uri, distribution, components, add_deb_src)
  components = components.join(' ') if components.respond_to?(:join)
  repo_info = "#{uri} #{distribution} #{components}\n"
  repo =  "deb     #{repo_info}"
  repo << "deb-src #{repo_info}" if add_deb_src
  repo
end

action :add do
    new_resource.updated_by_last_action(false)

    # add key
    if new_resource.keyserver && new_resource.key
      install_key_from_keyserver(new_resource.key, new_resource.keyserver)
    elsif new_resource.key
      install_key_from_uri(new_resource.key)
    end

    # build repo file
    repository = build_repo(new_resource.uri,
                            new_resource.distribution,
                            new_resource.components,
                            new_resource.deb_src)

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
