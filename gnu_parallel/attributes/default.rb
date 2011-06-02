#
# Cookbook Name:: gnu_parallel
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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
when "mac_os_x"
  default['gnu_parallel']['install_method'] = 'homebrew'
else
  default['gnu_parallel']['install_method'] = 'source'
end

default['gnu_parallel']['url'] = 'http://ftp.gnu.org/gnu/parallel'
default['gnu_parallel']['version'] = '20110522'
default['gnu_parallel']['checksum'] = '2e60c2052af9b49f8e82b5a32e19c6e9af5cb9b8bfd13717dab79a518dc867be'
default['gnu_parallel']['configure_options'] = []
