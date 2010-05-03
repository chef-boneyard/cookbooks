#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: couchdb
# Attributes:: couchdb
#
# Copyright 2010, Opscode, Inc
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

set[:couch_db][:src_checksum] = "2c6af7216537d0e399674a83e4505dc04a02abe1bdd966f69074564c3521c66b"
set[:couch_db][:src_version] = "0.9.1"
set[:couch_db][:src_mirror]  = "http://apache.osuosl.org/couchdb/#{couch_db.src_version}/apache-couchdb-#{couch_db.src_version}.tar.gz"
