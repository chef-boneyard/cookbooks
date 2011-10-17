#
# Author:: Barry Steinglass (<barry@opscode.com>)
# Cookbook Name:: wordpress
# Attributes:: wordpress
#
# Copyright 2009-2010, Opscode, Inc.
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

# General settings
default['wordpress']['version'] = "3.1.2"
default['wordpress']['checksum'] = "1006a1bb97b42381ad82490d00d9b7fb9f7a1c9d83ee2ed36935a9eb99c81064"
default['wordpress']['dir'] = "/var/www/wordpress"
default['wordpress']['db']['database'] = "wordpressdb"
default['wordpress']['db']['user'] = "wordpressuser"
