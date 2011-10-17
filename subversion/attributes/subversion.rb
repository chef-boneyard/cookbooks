#
# Cookbook Name:: subversion
# Attributes:: server
#
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

subversion Mash.new unless attribute?("subversion")
default.subversion.repo_dir     "/srv/svn"
default.subversion.repo_name    "repo"
default.subversion.server_name  "svn"         # hostname of apache virtual host
default.subversion.user         "subversion"
default.subversion.password     "subversion"  # please override this :)