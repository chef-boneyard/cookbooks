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

case node[:lsb][:codename]
when "intrepid","jaunty"
  package "djbdns" do
    action :install
  end
else
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
