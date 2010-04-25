#
# Cookbook Name:: passenger_enterprise
# Based on passenger_apache2
# attributes:: passenger_enterprise
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
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
set_unless[:passenger_enterprise][:version]     = "2.2.8"
set_unless[:passenger_enterprise][:root_path]   = "/opt/ruby-enterprise/lib/ruby/gems/1.8/gems/passenger-#{passenger_enterprise[:version]}"
set_unless[:passenger_enterprise][:module_path] = "#{passenger_enterprise[:root_path]}/ext/apache2/mod_passenger.so"
