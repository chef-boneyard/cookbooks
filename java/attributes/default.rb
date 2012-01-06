#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Bryan W. Berry (<bryan.berry@opscode.com>)
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

# default jdk attributes
default['java']['install_flavor'] = "openjdk"
default['java']['jdk_version'] = '6'
default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i586"

case platform
when "centos","redhat","fedora"
  default['java']['java_home'] = "/usr/lib/jvm/java"
else
  default['java']['java_home'] = "/usr/lib/jvm/default-java"
end

# jdk6 attributes
# x86_64
default['java']['jdk']['6']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u29-b11/jdk-6u29-linux-x64.bin'
default['java']['jdk']['6']['x86_64']['checksum'] =  'a8603fa62045ce2164b26f7c04859cd548ffe0e33bfc979d9fa73df42e3b3365'

# i586
default['java']['jdk']['6']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u29-b11/jdk-6u29-linux-i586.bin'
default['java']['jdk']['6']['i586']['checksum'] = '1117f4dfc45632b68ec0f4d5e61e5cafc1d85dc655ee3df5fa6f50128b8c3faf'

# jdk7 attributes
# x86_64
default['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u1-b08/jdk-7u1-linux-x64.tar.gz'
default['java']['jdk']['7']['x86_64']['checksum'] = 'f88070cfe7fe5ed60dfda7729cf9dd110b77840e2ca8cd14a86d5d2274b09c9c'

# i586
default['java']['jdk']['7']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u1-b08/jdk-7u1-linux-i586.tar.gz'
default['java']['jdk']['7']['i586']['checksum'] = 'acbfb8912a287facbee02ff138d94457aabab409b2f1d15855714ec9608a6cd4'
