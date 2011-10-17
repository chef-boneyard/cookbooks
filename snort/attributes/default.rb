#
# Cookbook Name:: snort
# Attributes:: default
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

case node['platform']
when "ubuntu", "debian"
  default['snort']['home_net'] = "192.168.0.0/16"
when "redhat","centos","fedora"
  default['snort']['home_net'] = "any"
  default['snort']['rpm']['version']                   = "2.9.0.3-1.F13"
  default['snort']['rpm']['checksum_snort']            = "7625fba04aa7ff2053f91406fa9ad457868ba711097000ca051ba2e0a245a904"
  default['snort']['rpm']['checksum_snort_mysql']      = "a2b5bf7f95994ccd1d59e97efba110ed2dcf97187f5db1c697bad20aaf8a2e90"
  default['snort']['rpm']['checksum_snort_postgresql'] = "94c8143dfd8b76944d0602948718750a17198b0ac50e9d1a5960f4e85b7fb7a8"
else
  default['snort']['home_net'] = "any"
end

default['snort']['database'] = 'none'
