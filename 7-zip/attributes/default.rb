#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: 7-zip
# Attribute:: default
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

if kernel['machine'] =~ /x86_64/
  default['7-zip']['url']          = "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi"
  default['7-zip']['checksum']     = "62df458bc521001cd9a947643a84810ecbaa5a16b5c8e87d80df8e34c4a16fe2"
  default['7-zip']['package_name'] = "7-Zip 9.20 (x64 edition)"
else
  default['7-zip']['url']          = "http://downloads.sourceforge.net/sevenzip/7z920.msi"
  default['7-zip']['checksum']     = "fe4807b4698ec89f82de7d85d32deaa4c772fc871537e31fb0fccf4473455cb8"
  default['7-zip']['package_name'] = "7-Zip 9.20"
end

default['7-zip']['home']    = "#{ENV['SYSTEMDRIVE']}\\7-zip"
