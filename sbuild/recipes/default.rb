#
# Cookbook Name:: sbuild
# Recipe:: default
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright 2010, Opscode, Inc. <legal@opscode.com>
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

packages = %w{
  apt-file
  dpkg-dev
  devscripts
  fakeroot
  cdbs
  quilt
  dpatch
  ruby-pkg-tools
  debootstrap
  debconf-utils
  debconf-doc
  gnupg
  schroot
  sbuild
  help2man
  reprepro
  git-buildpackage
  svn-buildpackage
}

case node[:platform]
when "ubuntu"
  packages << "ubuntu-dev-tools"
end

packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end

execute "echo dm_snapshot >> /etc/modules" do
  not_if "grep -q ^dm_snapshot /etc/modules"
end

search(:users, "groups:sbuild") do |u|
  group "sbuild" do
    members u['id']
    append true
  end
  template "/home/#{u['id']}/.sbuildrc" do
    source "sbuildrc.erb"
    mode 0640
    owner u['id']
    group "sbuild"
  end
  directory "/home/#{u['id']}/.cache" do
    mode 0750
    owner u['id']
    group "sbuild"
  end
end

remote_file "/usr/local/bin/schroot_update.sh" do
  source "schroot_update.sh"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/cron.d/schroot_update" do
  source "schroot_update.erb"
  owner "root"
  group "root"
  mode 00644
end
