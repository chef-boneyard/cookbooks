#
# Cookbook Name:: cloudkick
# Resource:: monitor
# Author:: Greg Albrecht <gba@splunk.com>
# Copyright:: Copyright (c) 2011 Splunk, Inc.
#
# License::
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
# LWRP 'Resource' for manipulating Cloudkick Monitors
#
# = See also:
#   * Cloudkick API Documentation: https://support.cloudkick.com/API/2.0
#

actions :create, :enable, :disable

attribute :oauth_key, :kind_of => String, :required => true
attribute :oauth_secret, :kind_of => String, :required => true
attribute :name, :kind_of => String, :name_attribute => true
# query will default to node=node.name
attribute :query, :kind_of => String
attribute :notes, :kind_of => String,
                  :default => 'Created by Cloudkick Chef Resource.'
