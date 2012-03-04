#
# Cookbook Name:: freebsd
# Provider:: port_option
#
# Copyright 2012, ZephirWorks
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

action :create do
  template new_resource.full_path do
    mode 0644
    source new_resource.source
    action :create
  end
end

def load_current_resource
  @current_resource = Chef::Resource::FreebsdPortOptions.new(@new_resource.name)

  @current_resource
end
