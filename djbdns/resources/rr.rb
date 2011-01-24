#
# Cookbook Name:: djbdns
# Resource:: rr
#
# Copyright 2011, Joshua Timberman <joshua@housepub.org>
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

# calls tinydns-edit: usage: tinydns-edit data data.new add [ns|childns|host|alias|mx] domain a.b.c.d
# e.g., tinydns-edit data data.new add host tester2.int.housepub.org 10.13.37.79

actions :add

attribute :fqdn,     :kind_of => String, :name_attribute => true
attribute :ip,       :kind_of => String, :required => true
attribute :type,     :kind_of => String, :default => "host"
attribute :cwd,      :kind_of => String
