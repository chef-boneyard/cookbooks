#
# Cookbook Name:: sbuild
# Attributes:: sbuild
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright 2010, Opscode, Inc. <legal@opscode.com>
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

set_unless[:sbuild][:mailto] = "root"
set_unless[:sbuild][:key_id] = ""
set_unless[:sbuild][:pgp_options] = "-us -uc"
set_unless[:sbuild][:maintainer_name] = ""
set_unless[:sbuild][:lv_size] = "5G"
set_unless[:sbuild][:snapshot_size] = "4G"
