#
# Cookbook Name:: radiant
# Attributes:: radiant
#
# Copyright 2009, Opscode, Inc.
# Copyright 2009, Daniel DeLeo
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

default['radiant']['branch']          = "HEAD"
default['radiant']['migrate']         = false
default['radiant']['migrate_command'] = "rake db:migrate"
default['radiant']['revision']     = "HEAD"
default['radiant']['action']       = "nothing"
default['radiant']['edge']         = false
default['radiant']['environment']  = chef_environment =~ /_default/ ? "production" : chef_environment
default['radiant']['db_bootstrap'] = <<EOS
yes | rake #{radiant['environment']} db:bootstrap \
ADMIN_NAME=Administrator \
ADMIN_USERNAME=admin \
ADMIN_PASSWORD=radiant \
DATABASE_TEMPLATE=empty.yml
EOS
