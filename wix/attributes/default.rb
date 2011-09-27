#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: wix
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

default['wix']['url']       = 'http://wix.sourceforge.net/releases/3.6.2109.0/wix36-binaries.zip'
default['wix']['checksum']  = '14d1ba5b3f4e3377c6a0e768d5dacd0c5231f0cc233de41e4126b29582656f55'

default['wix']['home']    = "#{ENV['SYSTEMDRIVE']}\\wix"
