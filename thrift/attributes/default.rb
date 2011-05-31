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

default['thrift']['version']  = '0.6.0'
default['thrift']['mirror']   = 'http://apache.mirrors.tds.net'
default['thrift']['checksum'] = 'c1a282de4d24c772cdf62ab110cf24937fd3c42d807e9cfd49d77c1488c0b7c5'
default['thrift']['configure_options'] = []
