#
# Cookbook Name:: postgresql
# Resource:: database
#
# Copyright:: 2008-2011, Opscode, Inc <legal@opscode.com>
# Copyright:: 2011, Atriso BVBA, <ringo.de.smet@atriso.be>
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

actions :create, :drop, :query
attribute :database, :kind_of => String, :required => "required"
attribute :owner, :kind_of => String, :default => nil
attribute :template, :kind_of => String, :default => 'DEFAULT'
attribute :encoding, :kind_of => String, :default => 'DEFAULT'
attribute :tablespace, :kind_of => String, :default => 'DEFAULT'
attribute :connection_limit, :kind_of => String, :default => '-1'

attribute :db_host, :kind_of => String, :default => '127.0.0.1'
attribute :db_port, :default => 5432
attribute :db_username, :kind_of => String, :default => 'postgres'
attribute :db_password, :kind_of => String, :default => nil