#
# Author:: Avishai Ish-Shalom <avishai@fewbytes.com>
# Cookbook Name:: php
# Recipe:: module_xcache
#
# Copyright 2010, Fewbytes LTD.
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

package "php5-xcache" do
  action :upgrade
end

template "/etc/php5/conf.d/xcache.ini" do
  source "xcache.ini.erb"
  mode 0644
end

