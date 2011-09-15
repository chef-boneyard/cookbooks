#
# Cookbook Name:: tar
# Resource:: package
#
# Author:: Nathan L Smith (<nathan@cramerdev.com>)
#
# Copyright 2011, Cramer Development, Inc.
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

actions :install

attribute :source, :name_attribute => true, :kind_of => String
attribute :prefix, :kind_of => String
attribute :source_directory, :kind_of => String, :default => '/usr/local/src'
attribute :creates, :kind_of => String
attribute :configure_flags, :kind_of => Array, :default => []

# Make :install the default action
def initialize(*args)
  super
  @action = :install
end
