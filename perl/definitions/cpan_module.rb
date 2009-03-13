#
# Cookbook Name:: perl
# Definition:: cpan_module
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

define :cpan_module, :force => nil do
  if params[:force]
    force = "force"
  end

  execute "install-#{params[:name]}" do
    command "echo #{force} install #{params[:name]} | /usr/bin/cpan"
    cwd "/root"
    path [ "/usr/local/bin", "/usr/bin", "/bin" ]
    not_if "perl -m#{params[:name]} ''"
  end
end
