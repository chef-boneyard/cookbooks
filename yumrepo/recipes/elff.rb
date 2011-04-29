#
# Cookbook Name:: yumrepo
# Recipe:: elff 
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

cookbook_file "#{node[:yumrepo][:key_path]}/RPM-GPG-KEY-ELFF"

yum_key "RPM-GPG-KEY-ELFF" do
  action :add
end

yum_repository "elff" do
  description "Enterprise Linux Fast Forward"
  key "RPM-GPG-KEY-ELFF"
  url "http://download.elff.bravenet.com/#{node[:platform_version].split('.')[0]}/$basearch"
  action :add
end
