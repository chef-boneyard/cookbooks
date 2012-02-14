#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
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

unless Chef::Config.solo?

  package "sudo" do
    action platform?("freebsd")? :install : :upgrade
  end

  raw_users = data_bag_item("sudoers", "users")
  users = raw_users['data']
  raw_user_aliases = data_bag_item("sudoers", "user_aliases")
  user_aliases = raw_user_aliases['data']
  raw_runas_aliases = data_bag_item("sudoers", "runas_aliases")
  runas_aliases = raw_runas_aliases['data']
  raw_command_aliases = data_bag_item("sudoers", "command_aliases")
  command_aliases = raw_command_aliases['data']

  # Add users to user aliases.  If you want to run all commands as all
  # users, assign the user to either the ADMINS or ADMINS_NOPASSWD alias.
  node[:sudo][:users].each do |u|
    if users.include?(u)
      unless users[u]["user_aliases"]
        raise "User #{u} must be a member of a user alias."
      end
      users[u]["user_aliases"].each do |ua| 
	user_aliases[ua]["users"].nil? ? user_aliases[ua]["users"] = Array.new : user_aliases[ua]["users"]
	Chef::Log.info "Adding #{u} to the #{ua} users alias"
	user_aliases[ua]["users"] << u
      end
    end
  end

  # Construct permissions from user aliases, runas aliases, the nopassword
  # option and command aliases.
  permissions = Array.new
  user_aliases.keys.each do |k|
    perm = "#{k} ALL="
    user_aliases[k]["runas"].nil? ? perm += "(ALL) " : perm += "(#{user_aliases[k]["runas"]}) "
    user_aliases[k]["nopasswd"] ? perm += "NOPASSWD: " : perm
    perm += user_aliases[k]["command_aliases"].join(", ")
    permissions << perm
  end

  # Default admins group.
  case node.platform
  when "freebsd", "centos", "redhat"
    adm_group = "wheel"
  when "ubuntu", "debian"
    adm_group = "admin"
  end

  template "/etc/sudoers" do
    path "/usr/local/etc/sudoers" if platform?("freebsd")
    path "/etc/sudoers.test" if node[:sudo][:testing]
    source "sudoers_databag.erb"
    mode 0440
    owner "root"
    group platform?("freebsd") ? "wheel" : "root"
    variables(
      :user_aliases => user_aliases,
      :runas_aliases => runas_aliases,
      :command_aliases => command_aliases,
      :permissions => permissions,
      :adm_group => adm_group
    )
  end
end
