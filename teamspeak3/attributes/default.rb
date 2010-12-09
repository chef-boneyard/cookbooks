#
# Author:: Joshua Timberman <joshua@housepub.org>
# Cookbook Name:: teamspeak3
# Attributes:: teamspeak3
#
# Copyright 2008-2009, Joshua Timberman
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

node.override[:ts3][:version] = "3.0.0-beta27"
node.default[:ts3][:arch] = kernel[:machine] =~ /x86_64/ ? "amd64" : "x86"
node.default[:ts3][:url] = "http://ftp.4players.de/pub/hosted/ts3/releases/beta-27/teamspeak3-server_linux-#{ts3[:arch]}-#{ts3[:version]}.tar.gz"
