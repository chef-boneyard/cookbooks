#
# Author:: Barry Steinglass (<barry@opscode.com>)
# Cookbook Name:: wordpress
# Attributes:: wordpress
#
# Copyright 2009-2010, Opscode, Inc.
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
set_unless[:wordpress][:version] = "2.9.2"
set_unless[:wordpress][:checksum] = "7342627f4a3dca44886c5aca6834cc88671dbd3aa2760182d2fcb9a330807ce1"
set_unless[:wordpress][:dir] = "/var/www/wordpress"
set_unless[:wordpress][:db][:database] = "wordpressdb"
set_unless[:wordpress][:db][:user] = "wordpressuser"

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:wordpress][:db][:password] = secure_password
set_unless[:wordpress][:keys][:auth] = secure_password
set_unless[:wordpress][:keys][:secure_auth] = secure_password
set_unless[:wordpress][:keys][:logged_in] = secure_password
set_unless[:wordpress][:keys][:nonce] = secure_password
