#
# Cookbook Name:: wordpress
# Attributes:: wordpress
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

# General settings
set_unless[:wordpress][:dir] = "/var/www"
set_unless[:wordpress][:db][:database] = "wordpressdb"
set_unless[:wordpress][:db][:user] = "wordpressuser"

db_password = ""
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| db_password << chars[rand(chars.size-1)] }
set_unless[:wordpress][:db][:password] = db_password 

auth_key = ""
secure_auth_key = ""
logged_in_key = ""
nonce_key = ""
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| auth_key << chars[rand(chars.size-1)] }
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| secure_auth_key << chars[rand(chars.size-1)] }
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| logged_in_key << chars[rand(chars.size-1)] }
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
20.times { |i| nonce_key << chars[rand(chars.size-1)] }

set_unless[:wordpress][:keys][:auth] = auth_key
set_unless[:wordpress][:keys][:secure_auth] = secure_auth_key
set_unless[:wordpress][:keys][:logged_in] = logged_in_key
set_unless[:wordpress][:keys][:nonce] = nonce_key 
