#
# Cookbook Name:: subversion
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0c
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "subversion" do
  action :install
end

extra_packages = case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f < 8.04
      %w{subversion-tools libsvn-core-perl}
    else
      %w{subversion-tools libsvn-perl}
    end
  when "debian"
    %{subversion-tools libsvn-perl}
  when "centos","redhat","fedora"
    %w{subversion-devel subversion-perl}
  end

extra_packages.each do |pkg|
  package pkg do
    action :install
  end
end
