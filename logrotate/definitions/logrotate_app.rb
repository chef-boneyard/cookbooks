#
# Cookbook Name:: logrotate
# Definition:: logrotate_instance
#
# Copyright 2009, Scott M. Likens
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

define :logrotate_app, :enable => true do
  include_recipe "logrotate"

    if params[:enable]
      template "/etc/logrotate.d/#{params[:name]}" do
        source "logrotate.erb"
        mode 0440
        owner "root"
        group "root"
        backup false
        variables(
          :paths => params[:paths],
          :rotate => params[:rotate]
        )
      end
    else
      execute "rm /etc/logrotate.d/#{params[:name]}" do
      only_if FileTest.exists?("/etc/logrotate.d/#{params[:name]}")
      command "rm /etc/logrotate.d/#{params[:name]}"
      end
    end
end

