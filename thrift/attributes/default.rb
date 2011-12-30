#
# Cookbook Name:: thrift
# Attributes:: default
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

default['thrift']['version']  = '0.8.0'
default['thrift']['mirror']   = 'http://apache.mirrors.tds.net'
default['thrift']['checksum'] = '5e280097d88400f5e2db75595a04e1981538e48869cd6915bb9c4831605f0793'
default['thrift']['configure_options'] = []
