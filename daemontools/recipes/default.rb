#
# Cookbook Name:: daemontools
# Recipe:: source
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "build-essential"
include_recipe "ucspi-tcp"

installation_method = value_for_platform(
    "arch" => { "default" => "aur" },
    "debian" => { "4.0" => "source", "default" => "package" },
    "ubuntu" => {
      "6.06" => "source",
      "6.10" => "source",
      "7.04" => "source",
      "7.10" => "source",
      "8.04" => "source",
      "8.10" => "source",
      "default" => "package"
    },
    "default" => { "default" => "source" }
)

case installation_method
when "package"
  package "daemontools" do
    action :install
  end
  case node[:platform]
  when "debian","ubuntu"
    package "daemontools-run" do
      action :install
    end
  end
when "aur"
  pacman_aur "daemontools" do
    patches ["daemontools-0.76.svscanboot-path-fix.patch"]
    pkgbuild_src true
    action [:build,:install]
  end
when "source"
  bash "install_daemontools" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz)
    (cd /tmp; tar zxvf daemontools-0.76.tar.gz)
    (cd /tmp/admin/daemontools-0.76; perl -pi -e 's/extern int errno;/\#include <errno.h>/' src/error.h)
    (cd /tmp/admin/daemontools-0.76; package/compile)
    (cd /tmp/admin/daemontools-0.76; mv command/* #{node[:daemontools][:bin_dir]})
    EOH
    only_if {::File.exists?("#{node[:daemontools][:bin_dir]}/svscan")}
  end
else
  Chef::Log.info("Could not find a method to install Daemon Tools for platform #{node[:platform]}, version #{node[:platform_version]}")
end
