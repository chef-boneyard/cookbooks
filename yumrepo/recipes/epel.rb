#
# Cookbook Name:: yumrepo
# Recipe:: epel 
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
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

yumrepo "epel" do
  action :enable
  definition "Extra Packages for Enterprise Linux"
  key "RPM-GPG-KEY-EPEL"
  url "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-#{node[:platform_version].split('.')[0]}&arch=$basearch"
  url_is_mirrorlist true
end
