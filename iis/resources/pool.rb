#
# Author:: Kendrick Martin (kendrick.martin@webtrends.com>)
# Cookbook Name:: iis
# Resource:: pool
#
# Copyright:: 2011, Webtrends
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

actions :add, :config, :delete, :start, :stop, :restart

attribute :pool_name, :kind_of => String, :name_attribute => true
attribute :runtime_version, :kind_of => String
attribute :pipeline_mode, :kind_of => Symbol, :default => :Classic, :equal_to => [:Integrated, :Classic]
attribute :private_mem, :kind_of => Integer, :default => 1048576
attribute :max_proc, :kind_of => Integer, :default => 2
attribute :thirty_two_bit, :kind_of => Symbol, :default => :false, :equal_to => [:true, :false]

attr_accessor :exists, :running