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

set_unless[:radiant][:branch]          = "HEAD"
set_unless[:radiant][:migrate]         = false
set_unless[:radiant][:migrate_command] = "rake db:migrate"
set_unless[:radiant][:environment]     = "production"
set_unless[:radiant][:revision]        = "HEAD"
set_unless[:radiant][:action]          = "nothing"
set_unless[:radiant][:edge]            = false
