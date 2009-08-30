#
# Cookbook Name:: djbdns
# Recipe:: default
# Author:: Joshua Timberman (<joshua@opscode.com>)
#
# Copyright 2009, Opscode, Inc
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
include_recipe "runit"

installation_method = value_for_platform(
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
  package "djbdns" do
    action :install
  end
when "source"
  bash "install_djbdns" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    (cd /tmp; wget http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz)
    (cd /tmp; tar zxvf ucspi-tcp-0.88.tar.gz)
    (cd /tmp/ucspi-tcp-0.88; perl -pi -e 's/extern int errno;/\#include <errno.h>/' error.h)
    (cd /tmp/ucspi-tcp-0.88; make setup check)
    (cd /tmp; wget http://cr.yp.to/djbdns/djbdns-1.05.tar.gz)
    (cd /tmp; tar xzvf djbdns-1.05.tar.gz)
    (cd /tmp/djbdns-1.05; perl -pi -e 's/extern int errno;/\#include <errno.h>/' error.h)
    (cd /tmp/djbdns-1.05; make setup check)
    EOH
    only_if "/usr/bin/test ! -f #{node[:djbdns][:bin_dir]}/tinydns"
  end
else
  Chef::Log.info("Could not find an installation method for platform #{node[:platform]}, version #{node[:platform_version]}")
end

user "dnscache" do
  uid 9997
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/dnscache"
end

user "dnslog" do
  uid 9998
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/dnslog"
end

user "tinydns" do
  uid 9999
  case node[:platform]
  when "ubuntu","debian"
    gid "nogroup"
  when "redhat", "centos"
    gid "nobody"
  else
    gid "nobody"
  end
  shell "/bin/false"
  home "/home/tinydns"
end
