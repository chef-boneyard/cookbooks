#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: gecode
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
when 'debian', 'ubuntu'
  default['gecode']['install_method'] = 'package'
else
  default['gecode']['install_method'] = 'source'
end

default['gecode']['url'] = 'http://www.gecode.org/download'
default['gecode']['version'] = '3.5.0'
default['gecode']['checksum'] = '0b2602ce647dd23814d2a7f5f0e757e09f98581b14b95aafbcd9e4c7e0ab4d2a'

default['gecode']['configure_options'] = %w{
                                          --disable-debug
                                          --disable-dependency-tracking
                                          --disable-qt
                                          --prefix=/usr/local
                                          --with-architectures=i386,x86_64
                                          }
