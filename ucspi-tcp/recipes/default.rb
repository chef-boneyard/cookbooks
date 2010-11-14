#
# Cookbook Name:: ucspi-tcp
# Recipe:: default
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

installation_method = value_for_platform(
    "arch" => { "default" => "aur" },
    "debian" => { "4.0" => "source", "default" => "package" },
    "ubuntu" => {
      "6.06" => "source",
      "6.10" => "source",
      "7.04" => "source",
      "7.10" => "source",
      "8.04" => "source",
      "default" => "package"
    },
    "default" => { "default" => "source" }
)

case installation_method
when "package"
  package "ucspi-tcp" do
    action :install
  end
when "aur"
  pacman_aur "ucspi-tcp" do
    action [:build,:install]
  end
when "source"
  bash "install_ucspi" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; wget http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz)
    (cd /tmp; tar zxvf ucspi-tcp-0.88.tar.gz)
    (cd /tmp/ucspi-tcp-0.88; perl -pi -e 's/extern int errno;/\#include <errno.h>/' error.h)
    (cd /tmp/ucspi-tcp-0.88; make setup check)
    EOH
    not_if { ::File.exists?("#{node[:ucspi][:bin_dir]}/tcpserver") }
  end
else
  Chef::Log.info("Could not find an installation method for platform #{node[:platform]}, version #{node[:platform_version]}")
end
