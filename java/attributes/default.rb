#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
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

default['java']['install_flavor'] = "openjdk"

case platform
when "centos","redhat","fedora"
  default['java']['version'] = "6u25"
  default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "amd64" : "i586"
  set['java']['java_home'] = "/usr/lib/jvm/java"
else
  set['java']['java_home'] = "/usr/lib/jvm/default-java"
end
