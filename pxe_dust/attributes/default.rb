#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: pxe_dust
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

default[:pxe_dust][:arch] = "amd64"
default[:pxe_dust][:version] = "maverick"
default[:pxe_dust][:user][:fullname] = "Ubuntu"
default[:pxe_dust][:user][:username] = "ubuntu"
default[:pxe_dust][:user][:crypted_password] = nil
