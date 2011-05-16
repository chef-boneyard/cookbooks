#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: chrony
# Attributes:: default
#
# Copyright 2011 Opscode, Inc
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

#hash of default servers in the chrony.conf from Ubuntu
default[:chrony][:servers] = {
  "0.debian.pool.ntp.org" => "offline minpoll 8",
  "1.debian.pool.ntp.org" => "offline minpoll 8",
  "2.debian.pool.ntp.org" => "offline minpoll 8",
  "3.debian.pool.ntp.org" => "offline minpoll 8"
}

default[:chrony][:server_options] = "offline minpoll 8"

#set in the client & master recipes
default[:chrony][:allow] = ["allow"]

#set in the client & master recipes
default[:chrony][:initslewstep] = ""
