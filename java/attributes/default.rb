#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Attributes:: ark
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

# default jdk attributes
default['java']['install_flavor'] = "openjdk"
default['java']['jdk_version'] = '6'
default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i586"

case platform
when "centos","redhat","fedora"
  default['java']['java_home'] = "/usr/lib/jvm/java"
when "freebsd"
  default['java']['java_home'] = "/usr/local/openjdk#{java['jdk_version']}"
when "arch"
  default['java']['java_home'] = "//usr/lib/jvm/java-#{java['jdk_version']}-openjdk"
else
  default['java']['java_home'] = "/usr/lib/jvm/default-java"
end

# jdk6 attributes
# x86_64
default['java']['jdk']['6']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u30-b12/jdk-6u30-linux-x64.bin'
default['java']['jdk']['6']['x86_64']['checksum'] = '928220f4e46c5dabef0440791c48023945629d8a23998e072157e04960d8a759'

# i586
default['java']['jdk']['6']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u30-b12/jdk-6u30-linux-i586.bin'
default['java']['jdk']['6']['i586']['checksum'] = 'b551be83a690bc9fec0107d9aa4f828cd47e150fa54cbedbfa8f80c99e2f18b5'

# jdk7 attributes
# x86_64
default['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u2-b13/jdk-7u2-linux-x64.tar.gz'
default['java']['jdk']['7']['x86_64']['checksum'] = '411a204122c5e45876d6edae1a031b718c01e6175833740b406e8aafc37bc82d'

# i586
default['java']['jdk']['7']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u2-b13/jdk-7u2-linux-i586.tar.gz'
default['java']['jdk']['7']['i586']['checksum'] = '74faad48fef2c368276dbd1fd6c02520b0e9ebdcb1621916c1af345fc3ba65d1'
