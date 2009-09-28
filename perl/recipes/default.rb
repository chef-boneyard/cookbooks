#
# Cookbook Name:: perl
# Recipe:: default
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

package "perl" do
  action :upgrade
end

package "libwww-perl" do
  case node[:platform]
  when "centos"
    name "perl-libwww-perl"
  end
  action :upgrade
end

package "libperl-dev" do
  case node[:platform]
  when "centos"
    action :nothing
  else
    action :upgrade
  end
end

directory "/root/.cpan" do
  owner "root"
  group "root"
  mode 0750
end

remote_file "CPAN-Config.pm" do
  case node[:platform]
  when "centos","redhat"
    path "/usr/lib/perl5/5.8.8/CPAN/Config.pm"
  else
    path "/etc/perl/CPAN/Config.pm"
  end
  source "Config-#{node[:languages][:perl][:version]}.pm"
  owner "root"
  group "root"
  mode 0644
end

remote_file "/usr/local/bin/cpan_install" do
  source "cpan_install"
  owner "root"
  group "root"
  mode 0755
end
