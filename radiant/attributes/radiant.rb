#
# Cookbook Name:: radiant
# Attributes:: radiant
#
# Copyright 2009, Opscode, Inc.
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


radiant Mash.new unless attribute?("radiant")
radiant[:branch] = "HEAD" unless radiant.has_key?(:branch)
radiant[:migrate] = false unless radiant.has_key?(:migrate)
radiant[:migrate_command] = "rake db:migrate" unless radiant.has_key?(:migrate_command)
radiant[:environment] = "production" unless radiant.has_key?(:environment)
radiant[:revision] = "HEAD" unless radiant.has_key?(:revision)
radiant[:action] = "nothing" unless radiant.has_key?(:action)
radiant[:edge] = false unless radiant.has_key?(:edge)
radiant[:bootstrap] = false unless radiant.has_key(:bootstrap)
radiant[:admin_name] = "Administrator" unless radiant.has_key?(:admin_name)
radiant[:admin_username] = "admin" unless radiant.has_key(:admin_username)
radiant[:admin_password] = "radiant" unless radiant.has_key(:admin_password)
radiant[:database_template] = "empty.yml" unless radiant.has_key(:database_template)
