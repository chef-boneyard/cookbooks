#
# Cookbook Name:: yumrepo
# Recipe:: postgresql9
#
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

cookbook_file "#{node[:yumrepo][:key_path]}/RPM-GPG-KEY-PGDG"

yum_key "RPM-GPG-KEY-PGDG" do
  action :add
end

yum_repository "postgresql9" do
  description "PostgreSQL 9.0"
  key "RPM-GPG-KEY-PGDG"
  url "http://yum.pgrpms.org/9.0/redhat/rhel-$releasever-$basearch"
  action :add
end
