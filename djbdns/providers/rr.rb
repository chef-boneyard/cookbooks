#
# Cookbook Name:: djbdns
# Provider:: rr
#
# Copyright 2011, Joshua Timberman <joshua@housepub.org>
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

action :add do
  type = new_resource.type
  fqdn = new_resource.fqdn
  ip = new_resource.ip
  cwd = new_resource.cwd ? new_resource.cwd : "#{node[:djbdns][:tinydns_internal_dir]}/root"

  execute "./add-#{type} #{fqdn} #{ip}" do
    cwd cwd
    ignore_failure true
    not_if "grep '^[\.\+=]#{fqdn}:#{ip}' #{cwd}/data"
  end
  new_resource.updated_by_last_action(true)
end
